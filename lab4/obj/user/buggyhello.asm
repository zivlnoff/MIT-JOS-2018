
obj/user/buggyhello：     文件格式 elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 5d 00 00 00       	call   80009f <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800052:	e8 c6 00 00 00       	call   80011d <sys_getenvid>
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800064:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800069:	85 db                	test   %ebx,%ebx
  80006b:	7e 07                	jle    800074 <libmain+0x2d>
		binaryname = argv[0];
  80006d:	8b 06                	mov    (%esi),%eax
  80006f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800074:	83 ec 08             	sub    $0x8,%esp
  800077:	56                   	push   %esi
  800078:	53                   	push   %ebx
  800079:	e8 b5 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007e:	e8 0a 00 00 00       	call   80008d <exit>
}
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800089:	5b                   	pop    %ebx
  80008a:	5e                   	pop    %esi
  80008b:	5d                   	pop    %ebp
  80008c:	c3                   	ret    

0080008d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008d:	55                   	push   %ebp
  80008e:	89 e5                	mov    %esp,%ebp
  800090:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800093:	6a 00                	push   $0x0
  800095:	e8 42 00 00 00       	call   8000dc <sys_env_destroy>
}
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	c9                   	leave  
  80009e:	c3                   	ret    

0080009f <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80009f:	55                   	push   %ebp
  8000a0:	89 e5                	mov    %esp,%ebp
  8000a2:	57                   	push   %edi
  8000a3:	56                   	push   %esi
  8000a4:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b0:	89 c3                	mov    %eax,%ebx
  8000b2:	89 c7                	mov    %eax,%edi
  8000b4:	89 c6                	mov    %eax,%esi
  8000b6:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000b8:	5b                   	pop    %ebx
  8000b9:	5e                   	pop    %esi
  8000ba:	5f                   	pop    %edi
  8000bb:	5d                   	pop    %ebp
  8000bc:	c3                   	ret    

008000bd <sys_cgetc>:

int
sys_cgetc(void) {
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	57                   	push   %edi
  8000c1:	56                   	push   %esi
  8000c2:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8000cd:	89 d1                	mov    %edx,%ecx
  8000cf:	89 d3                	mov    %edx,%ebx
  8000d1:	89 d7                	mov    %edx,%edi
  8000d3:	89 d6                	mov    %edx,%esi
  8000d5:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d7:	5b                   	pop    %ebx
  8000d8:	5e                   	pop    %esi
  8000d9:	5f                   	pop    %edi
  8000da:	5d                   	pop    %ebp
  8000db:	c3                   	ret    

008000dc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	57                   	push   %edi
  8000e0:	56                   	push   %esi
  8000e1:	53                   	push   %ebx
  8000e2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f2:	89 cb                	mov    %ecx,%ebx
  8000f4:	89 cf                	mov    %ecx,%edi
  8000f6:	89 ce                	mov    %ecx,%esi
  8000f8:	cd 30                	int    $0x30
    if (check && ret > 0)
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	7f 08                	jg     800106 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800101:	5b                   	pop    %ebx
  800102:	5e                   	pop    %esi
  800103:	5f                   	pop    %edi
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	50                   	push   %eax
  80010a:	6a 03                	push   $0x3
  80010c:	68 ca 0f 80 00       	push   $0x800fca
  800111:	6a 24                	push   $0x24
  800113:	68 e7 0f 80 00       	push   $0x800fe7
  800118:	e8 ed 01 00 00       	call   80030a <_panic>

0080011d <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80011d:	55                   	push   %ebp
  80011e:	89 e5                	mov    %esp,%ebp
  800120:	57                   	push   %edi
  800121:	56                   	push   %esi
  800122:	53                   	push   %ebx
    asm volatile("int %1\n"
  800123:	ba 00 00 00 00       	mov    $0x0,%edx
  800128:	b8 02 00 00 00       	mov    $0x2,%eax
  80012d:	89 d1                	mov    %edx,%ecx
  80012f:	89 d3                	mov    %edx,%ebx
  800131:	89 d7                	mov    %edx,%edi
  800133:	89 d6                	mov    %edx,%esi
  800135:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800137:	5b                   	pop    %ebx
  800138:	5e                   	pop    %esi
  800139:	5f                   	pop    %edi
  80013a:	5d                   	pop    %ebp
  80013b:	c3                   	ret    

0080013c <sys_yield>:

void
sys_yield(void)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	57                   	push   %edi
  800140:	56                   	push   %esi
  800141:	53                   	push   %ebx
    asm volatile("int %1\n"
  800142:	ba 00 00 00 00       	mov    $0x0,%edx
  800147:	b8 0a 00 00 00       	mov    $0xa,%eax
  80014c:	89 d1                	mov    %edx,%ecx
  80014e:	89 d3                	mov    %edx,%ebx
  800150:	89 d7                	mov    %edx,%edi
  800152:	89 d6                	mov    %edx,%esi
  800154:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800156:	5b                   	pop    %ebx
  800157:	5e                   	pop    %esi
  800158:	5f                   	pop    %edi
  800159:	5d                   	pop    %ebp
  80015a:	c3                   	ret    

0080015b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	57                   	push   %edi
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
  800161:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800164:	be 00 00 00 00       	mov    $0x0,%esi
  800169:	8b 55 08             	mov    0x8(%ebp),%edx
  80016c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016f:	b8 04 00 00 00       	mov    $0x4,%eax
  800174:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800177:	89 f7                	mov    %esi,%edi
  800179:	cd 30                	int    $0x30
    if (check && ret > 0)
  80017b:	85 c0                	test   %eax,%eax
  80017d:	7f 08                	jg     800187 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800182:	5b                   	pop    %ebx
  800183:	5e                   	pop    %esi
  800184:	5f                   	pop    %edi
  800185:	5d                   	pop    %ebp
  800186:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	50                   	push   %eax
  80018b:	6a 04                	push   $0x4
  80018d:	68 ca 0f 80 00       	push   $0x800fca
  800192:	6a 24                	push   $0x24
  800194:	68 e7 0f 80 00       	push   $0x800fe7
  800199:	e8 6c 01 00 00       	call   80030a <_panic>

0080019e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	57                   	push   %edi
  8001a2:	56                   	push   %esi
  8001a3:	53                   	push   %ebx
  8001a4:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ad:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b8:	8b 75 18             	mov    0x18(%ebp),%esi
  8001bb:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001bd:	85 c0                	test   %eax,%eax
  8001bf:	7f 08                	jg     8001c9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c4:	5b                   	pop    %ebx
  8001c5:	5e                   	pop    %esi
  8001c6:	5f                   	pop    %edi
  8001c7:	5d                   	pop    %ebp
  8001c8:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	50                   	push   %eax
  8001cd:	6a 05                	push   $0x5
  8001cf:	68 ca 0f 80 00       	push   $0x800fca
  8001d4:	6a 24                	push   $0x24
  8001d6:	68 e7 0f 80 00       	push   $0x800fe7
  8001db:	e8 2a 01 00 00       	call   80030a <_panic>

008001e0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	57                   	push   %edi
  8001e4:	56                   	push   %esi
  8001e5:	53                   	push   %ebx
  8001e6:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f4:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f9:	89 df                	mov    %ebx,%edi
  8001fb:	89 de                	mov    %ebx,%esi
  8001fd:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001ff:	85 c0                	test   %eax,%eax
  800201:	7f 08                	jg     80020b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800203:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800206:	5b                   	pop    %ebx
  800207:	5e                   	pop    %esi
  800208:	5f                   	pop    %edi
  800209:	5d                   	pop    %ebp
  80020a:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	50                   	push   %eax
  80020f:	6a 06                	push   $0x6
  800211:	68 ca 0f 80 00       	push   $0x800fca
  800216:	6a 24                	push   $0x24
  800218:	68 e7 0f 80 00       	push   $0x800fe7
  80021d:	e8 e8 00 00 00       	call   80030a <_panic>

00800222 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	57                   	push   %edi
  800226:	56                   	push   %esi
  800227:	53                   	push   %ebx
  800228:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80022b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800230:	8b 55 08             	mov    0x8(%ebp),%edx
  800233:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800236:	b8 08 00 00 00       	mov    $0x8,%eax
  80023b:	89 df                	mov    %ebx,%edi
  80023d:	89 de                	mov    %ebx,%esi
  80023f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800241:	85 c0                	test   %eax,%eax
  800243:	7f 08                	jg     80024d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800248:	5b                   	pop    %ebx
  800249:	5e                   	pop    %esi
  80024a:	5f                   	pop    %edi
  80024b:	5d                   	pop    %ebp
  80024c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	50                   	push   %eax
  800251:	6a 08                	push   $0x8
  800253:	68 ca 0f 80 00       	push   $0x800fca
  800258:	6a 24                	push   $0x24
  80025a:	68 e7 0f 80 00       	push   $0x800fe7
  80025f:	e8 a6 00 00 00       	call   80030a <_panic>

00800264 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	57                   	push   %edi
  800268:	56                   	push   %esi
  800269:	53                   	push   %ebx
  80026a:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80026d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800272:	8b 55 08             	mov    0x8(%ebp),%edx
  800275:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800278:	b8 09 00 00 00       	mov    $0x9,%eax
  80027d:	89 df                	mov    %ebx,%edi
  80027f:	89 de                	mov    %ebx,%esi
  800281:	cd 30                	int    $0x30
    if (check && ret > 0)
  800283:	85 c0                	test   %eax,%eax
  800285:	7f 08                	jg     80028f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800287:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028a:	5b                   	pop    %ebx
  80028b:	5e                   	pop    %esi
  80028c:	5f                   	pop    %edi
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	6a 09                	push   $0x9
  800295:	68 ca 0f 80 00       	push   $0x800fca
  80029a:	6a 24                	push   $0x24
  80029c:	68 e7 0f 80 00       	push   $0x800fe7
  8002a1:	e8 64 00 00 00       	call   80030a <_panic>

008002a6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	57                   	push   %edi
  8002aa:	56                   	push   %esi
  8002ab:	53                   	push   %ebx
    asm volatile("int %1\n"
  8002ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8002af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b2:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002b7:	be 00 00 00 00       	mov    $0x0,%esi
  8002bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002c2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002c4:	5b                   	pop    %ebx
  8002c5:	5e                   	pop    %esi
  8002c6:	5f                   	pop    %edi
  8002c7:	5d                   	pop    %ebp
  8002c8:	c3                   	ret    

008002c9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	57                   	push   %edi
  8002cd:	56                   	push   %esi
  8002ce:	53                   	push   %ebx
  8002cf:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002da:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002df:	89 cb                	mov    %ecx,%ebx
  8002e1:	89 cf                	mov    %ecx,%edi
  8002e3:	89 ce                	mov    %ecx,%esi
  8002e5:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002e7:	85 c0                	test   %eax,%eax
  8002e9:	7f 08                	jg     8002f3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ee:	5b                   	pop    %ebx
  8002ef:	5e                   	pop    %esi
  8002f0:	5f                   	pop    %edi
  8002f1:	5d                   	pop    %ebp
  8002f2:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	50                   	push   %eax
  8002f7:	6a 0c                	push   $0xc
  8002f9:	68 ca 0f 80 00       	push   $0x800fca
  8002fe:	6a 24                	push   $0x24
  800300:	68 e7 0f 80 00       	push   $0x800fe7
  800305:	e8 00 00 00 00       	call   80030a <_panic>

0080030a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	56                   	push   %esi
  80030e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80030f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800312:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800318:	e8 00 fe ff ff       	call   80011d <sys_getenvid>
  80031d:	83 ec 0c             	sub    $0xc,%esp
  800320:	ff 75 0c             	pushl  0xc(%ebp)
  800323:	ff 75 08             	pushl  0x8(%ebp)
  800326:	56                   	push   %esi
  800327:	50                   	push   %eax
  800328:	68 f8 0f 80 00       	push   $0x800ff8
  80032d:	e8 b3 00 00 00       	call   8003e5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800332:	83 c4 18             	add    $0x18,%esp
  800335:	53                   	push   %ebx
  800336:	ff 75 10             	pushl  0x10(%ebp)
  800339:	e8 56 00 00 00       	call   800394 <vcprintf>
	cprintf("\n");
  80033e:	c7 04 24 1c 10 80 00 	movl   $0x80101c,(%esp)
  800345:	e8 9b 00 00 00       	call   8003e5 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80034d:	cc                   	int3   
  80034e:	eb fd                	jmp    80034d <_panic+0x43>

00800350 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	53                   	push   %ebx
  800354:	83 ec 04             	sub    $0x4,%esp
  800357:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80035a:	8b 13                	mov    (%ebx),%edx
  80035c:	8d 42 01             	lea    0x1(%edx),%eax
  80035f:	89 03                	mov    %eax,(%ebx)
  800361:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800364:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800368:	3d ff 00 00 00       	cmp    $0xff,%eax
  80036d:	74 09                	je     800378 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80036f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800376:	c9                   	leave  
  800377:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800378:	83 ec 08             	sub    $0x8,%esp
  80037b:	68 ff 00 00 00       	push   $0xff
  800380:	8d 43 08             	lea    0x8(%ebx),%eax
  800383:	50                   	push   %eax
  800384:	e8 16 fd ff ff       	call   80009f <sys_cputs>
		b->idx = 0;
  800389:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	eb db                	jmp    80036f <putch+0x1f>

00800394 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80039d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003a4:	00 00 00 
	b.cnt = 0;
  8003a7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ae:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003bd:	50                   	push   %eax
  8003be:	68 50 03 80 00       	push   $0x800350
  8003c3:	e8 1a 01 00 00       	call   8004e2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003c8:	83 c4 08             	add    $0x8,%esp
  8003cb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003d1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003d7:	50                   	push   %eax
  8003d8:	e8 c2 fc ff ff       	call   80009f <sys_cputs>

	return b.cnt;
}
  8003dd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003e3:	c9                   	leave  
  8003e4:	c3                   	ret    

008003e5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003eb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003ee:	50                   	push   %eax
  8003ef:	ff 75 08             	pushl  0x8(%ebp)
  8003f2:	e8 9d ff ff ff       	call   800394 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003f7:	c9                   	leave  
  8003f8:	c3                   	ret    

008003f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f9:	55                   	push   %ebp
  8003fa:	89 e5                	mov    %esp,%ebp
  8003fc:	57                   	push   %edi
  8003fd:	56                   	push   %esi
  8003fe:	53                   	push   %ebx
  8003ff:	83 ec 1c             	sub    $0x1c,%esp
  800402:	89 c7                	mov    %eax,%edi
  800404:	89 d6                	mov    %edx,%esi
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	8b 55 0c             	mov    0xc(%ebp),%edx
  80040c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80040f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800412:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800415:	bb 00 00 00 00       	mov    $0x0,%ebx
  80041a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80041d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800420:	39 d3                	cmp    %edx,%ebx
  800422:	72 05                	jb     800429 <printnum+0x30>
  800424:	39 45 10             	cmp    %eax,0x10(%ebp)
  800427:	77 7a                	ja     8004a3 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800429:	83 ec 0c             	sub    $0xc,%esp
  80042c:	ff 75 18             	pushl  0x18(%ebp)
  80042f:	8b 45 14             	mov    0x14(%ebp),%eax
  800432:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800435:	53                   	push   %ebx
  800436:	ff 75 10             	pushl  0x10(%ebp)
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80043f:	ff 75 e0             	pushl  -0x20(%ebp)
  800442:	ff 75 dc             	pushl  -0x24(%ebp)
  800445:	ff 75 d8             	pushl  -0x28(%ebp)
  800448:	e8 33 09 00 00       	call   800d80 <__udivdi3>
  80044d:	83 c4 18             	add    $0x18,%esp
  800450:	52                   	push   %edx
  800451:	50                   	push   %eax
  800452:	89 f2                	mov    %esi,%edx
  800454:	89 f8                	mov    %edi,%eax
  800456:	e8 9e ff ff ff       	call   8003f9 <printnum>
  80045b:	83 c4 20             	add    $0x20,%esp
  80045e:	eb 13                	jmp    800473 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	56                   	push   %esi
  800464:	ff 75 18             	pushl  0x18(%ebp)
  800467:	ff d7                	call   *%edi
  800469:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80046c:	83 eb 01             	sub    $0x1,%ebx
  80046f:	85 db                	test   %ebx,%ebx
  800471:	7f ed                	jg     800460 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	56                   	push   %esi
  800477:	83 ec 04             	sub    $0x4,%esp
  80047a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80047d:	ff 75 e0             	pushl  -0x20(%ebp)
  800480:	ff 75 dc             	pushl  -0x24(%ebp)
  800483:	ff 75 d8             	pushl  -0x28(%ebp)
  800486:	e8 15 0a 00 00       	call   800ea0 <__umoddi3>
  80048b:	83 c4 14             	add    $0x14,%esp
  80048e:	0f be 80 1e 10 80 00 	movsbl 0x80101e(%eax),%eax
  800495:	50                   	push   %eax
  800496:	ff d7                	call   *%edi
}
  800498:	83 c4 10             	add    $0x10,%esp
  80049b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80049e:	5b                   	pop    %ebx
  80049f:	5e                   	pop    %esi
  8004a0:	5f                   	pop    %edi
  8004a1:	5d                   	pop    %ebp
  8004a2:	c3                   	ret    
  8004a3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004a6:	eb c4                	jmp    80046c <printnum+0x73>

008004a8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004a8:	55                   	push   %ebp
  8004a9:	89 e5                	mov    %esp,%ebp
  8004ab:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004ae:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004b2:	8b 10                	mov    (%eax),%edx
  8004b4:	3b 50 04             	cmp    0x4(%eax),%edx
  8004b7:	73 0a                	jae    8004c3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004b9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004bc:	89 08                	mov    %ecx,(%eax)
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	88 02                	mov    %al,(%edx)
}
  8004c3:	5d                   	pop    %ebp
  8004c4:	c3                   	ret    

008004c5 <printfmt>:
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004cb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ce:	50                   	push   %eax
  8004cf:	ff 75 10             	pushl  0x10(%ebp)
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	e8 05 00 00 00       	call   8004e2 <vprintfmt>
}
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	c9                   	leave  
  8004e1:	c3                   	ret    

008004e2 <vprintfmt>:
{
  8004e2:	55                   	push   %ebp
  8004e3:	89 e5                	mov    %esp,%ebp
  8004e5:	57                   	push   %edi
  8004e6:	56                   	push   %esi
  8004e7:	53                   	push   %ebx
  8004e8:	83 ec 2c             	sub    $0x2c,%esp
  8004eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004f1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004f4:	e9 00 04 00 00       	jmp    8008f9 <vprintfmt+0x417>
		padc = ' ';
  8004f9:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8004fd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800504:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80050b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800512:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800517:	8d 47 01             	lea    0x1(%edi),%eax
  80051a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80051d:	0f b6 17             	movzbl (%edi),%edx
  800520:	8d 42 dd             	lea    -0x23(%edx),%eax
  800523:	3c 55                	cmp    $0x55,%al
  800525:	0f 87 51 04 00 00    	ja     80097c <vprintfmt+0x49a>
  80052b:	0f b6 c0             	movzbl %al,%eax
  80052e:	ff 24 85 e0 10 80 00 	jmp    *0x8010e0(,%eax,4)
  800535:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800538:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80053c:	eb d9                	jmp    800517 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80053e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800541:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800545:	eb d0                	jmp    800517 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800547:	0f b6 d2             	movzbl %dl,%edx
  80054a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80054d:	b8 00 00 00 00       	mov    $0x0,%eax
  800552:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800555:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800558:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80055c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80055f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800562:	83 f9 09             	cmp    $0x9,%ecx
  800565:	77 55                	ja     8005bc <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800567:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80056a:	eb e9                	jmp    800555 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 40 04             	lea    0x4(%eax),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80057d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800580:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800584:	79 91                	jns    800517 <vprintfmt+0x35>
				width = precision, precision = -1;
  800586:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800589:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80058c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800593:	eb 82                	jmp    800517 <vprintfmt+0x35>
  800595:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800598:	85 c0                	test   %eax,%eax
  80059a:	ba 00 00 00 00       	mov    $0x0,%edx
  80059f:	0f 49 d0             	cmovns %eax,%edx
  8005a2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005a8:	e9 6a ff ff ff       	jmp    800517 <vprintfmt+0x35>
  8005ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005b0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005b7:	e9 5b ff ff ff       	jmp    800517 <vprintfmt+0x35>
  8005bc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005c2:	eb bc                	jmp    800580 <vprintfmt+0x9e>
			lflag++;
  8005c4:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005ca:	e9 48 ff ff ff       	jmp    800517 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8d 78 04             	lea    0x4(%eax),%edi
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	53                   	push   %ebx
  8005d9:	ff 30                	pushl  (%eax)
  8005db:	ff d6                	call   *%esi
			break;
  8005dd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005e0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005e3:	e9 0e 03 00 00       	jmp    8008f6 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8d 78 04             	lea    0x4(%eax),%edi
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	99                   	cltd   
  8005f1:	31 d0                	xor    %edx,%eax
  8005f3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005f5:	83 f8 08             	cmp    $0x8,%eax
  8005f8:	7f 23                	jg     80061d <vprintfmt+0x13b>
  8005fa:	8b 14 85 40 12 80 00 	mov    0x801240(,%eax,4),%edx
  800601:	85 d2                	test   %edx,%edx
  800603:	74 18                	je     80061d <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800605:	52                   	push   %edx
  800606:	68 3f 10 80 00       	push   $0x80103f
  80060b:	53                   	push   %ebx
  80060c:	56                   	push   %esi
  80060d:	e8 b3 fe ff ff       	call   8004c5 <printfmt>
  800612:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800615:	89 7d 14             	mov    %edi,0x14(%ebp)
  800618:	e9 d9 02 00 00       	jmp    8008f6 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  80061d:	50                   	push   %eax
  80061e:	68 36 10 80 00       	push   $0x801036
  800623:	53                   	push   %ebx
  800624:	56                   	push   %esi
  800625:	e8 9b fe ff ff       	call   8004c5 <printfmt>
  80062a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80062d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800630:	e9 c1 02 00 00       	jmp    8008f6 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	83 c0 04             	add    $0x4,%eax
  80063b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800643:	85 ff                	test   %edi,%edi
  800645:	b8 2f 10 80 00       	mov    $0x80102f,%eax
  80064a:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80064d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800651:	0f 8e bd 00 00 00    	jle    800714 <vprintfmt+0x232>
  800657:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80065b:	75 0e                	jne    80066b <vprintfmt+0x189>
  80065d:	89 75 08             	mov    %esi,0x8(%ebp)
  800660:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800663:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800666:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800669:	eb 6d                	jmp    8006d8 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	ff 75 d0             	pushl  -0x30(%ebp)
  800671:	57                   	push   %edi
  800672:	e8 ad 03 00 00       	call   800a24 <strnlen>
  800677:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80067a:	29 c1                	sub    %eax,%ecx
  80067c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80067f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800682:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800686:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800689:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80068c:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80068e:	eb 0f                	jmp    80069f <vprintfmt+0x1bd>
					putch(padc, putdat);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	ff 75 e0             	pushl  -0x20(%ebp)
  800697:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800699:	83 ef 01             	sub    $0x1,%edi
  80069c:	83 c4 10             	add    $0x10,%esp
  80069f:	85 ff                	test   %edi,%edi
  8006a1:	7f ed                	jg     800690 <vprintfmt+0x1ae>
  8006a3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006a6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006a9:	85 c9                	test   %ecx,%ecx
  8006ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b0:	0f 49 c1             	cmovns %ecx,%eax
  8006b3:	29 c1                	sub    %eax,%ecx
  8006b5:	89 75 08             	mov    %esi,0x8(%ebp)
  8006b8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006bb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006be:	89 cb                	mov    %ecx,%ebx
  8006c0:	eb 16                	jmp    8006d8 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006c2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c6:	75 31                	jne    8006f9 <vprintfmt+0x217>
					putch(ch, putdat);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	50                   	push   %eax
  8006cf:	ff 55 08             	call   *0x8(%ebp)
  8006d2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d5:	83 eb 01             	sub    $0x1,%ebx
  8006d8:	83 c7 01             	add    $0x1,%edi
  8006db:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006df:	0f be c2             	movsbl %dl,%eax
  8006e2:	85 c0                	test   %eax,%eax
  8006e4:	74 59                	je     80073f <vprintfmt+0x25d>
  8006e6:	85 f6                	test   %esi,%esi
  8006e8:	78 d8                	js     8006c2 <vprintfmt+0x1e0>
  8006ea:	83 ee 01             	sub    $0x1,%esi
  8006ed:	79 d3                	jns    8006c2 <vprintfmt+0x1e0>
  8006ef:	89 df                	mov    %ebx,%edi
  8006f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8006f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006f7:	eb 37                	jmp    800730 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006f9:	0f be d2             	movsbl %dl,%edx
  8006fc:	83 ea 20             	sub    $0x20,%edx
  8006ff:	83 fa 5e             	cmp    $0x5e,%edx
  800702:	76 c4                	jbe    8006c8 <vprintfmt+0x1e6>
					putch('?', putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	6a 3f                	push   $0x3f
  80070c:	ff 55 08             	call   *0x8(%ebp)
  80070f:	83 c4 10             	add    $0x10,%esp
  800712:	eb c1                	jmp    8006d5 <vprintfmt+0x1f3>
  800714:	89 75 08             	mov    %esi,0x8(%ebp)
  800717:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80071a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80071d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800720:	eb b6                	jmp    8006d8 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	53                   	push   %ebx
  800726:	6a 20                	push   $0x20
  800728:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80072a:	83 ef 01             	sub    $0x1,%edi
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	85 ff                	test   %edi,%edi
  800732:	7f ee                	jg     800722 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800734:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800737:	89 45 14             	mov    %eax,0x14(%ebp)
  80073a:	e9 b7 01 00 00       	jmp    8008f6 <vprintfmt+0x414>
  80073f:	89 df                	mov    %ebx,%edi
  800741:	8b 75 08             	mov    0x8(%ebp),%esi
  800744:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800747:	eb e7                	jmp    800730 <vprintfmt+0x24e>
	if (lflag >= 2)
  800749:	83 f9 01             	cmp    $0x1,%ecx
  80074c:	7e 3f                	jle    80078d <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8b 50 04             	mov    0x4(%eax),%edx
  800754:	8b 00                	mov    (%eax),%eax
  800756:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800759:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8d 40 08             	lea    0x8(%eax),%eax
  800762:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800765:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800769:	79 5c                	jns    8007c7 <vprintfmt+0x2e5>
				putch('-', putdat);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	53                   	push   %ebx
  80076f:	6a 2d                	push   $0x2d
  800771:	ff d6                	call   *%esi
				num = -(long long) num;
  800773:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800776:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800779:	f7 da                	neg    %edx
  80077b:	83 d1 00             	adc    $0x0,%ecx
  80077e:	f7 d9                	neg    %ecx
  800780:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800783:	b8 0a 00 00 00       	mov    $0xa,%eax
  800788:	e9 4f 01 00 00       	jmp    8008dc <vprintfmt+0x3fa>
	else if (lflag)
  80078d:	85 c9                	test   %ecx,%ecx
  80078f:	75 1b                	jne    8007ac <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800799:	89 c1                	mov    %eax,%ecx
  80079b:	c1 f9 1f             	sar    $0x1f,%ecx
  80079e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a4:	8d 40 04             	lea    0x4(%eax),%eax
  8007a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007aa:	eb b9                	jmp    800765 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b4:	89 c1                	mov    %eax,%ecx
  8007b6:	c1 f9 1f             	sar    $0x1f,%ecx
  8007b9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8d 40 04             	lea    0x4(%eax),%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c5:	eb 9e                	jmp    800765 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007c7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d2:	e9 05 01 00 00       	jmp    8008dc <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007d7:	83 f9 01             	cmp    $0x1,%ecx
  8007da:	7e 18                	jle    8007f4 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8b 10                	mov    (%eax),%edx
  8007e1:	8b 48 04             	mov    0x4(%eax),%ecx
  8007e4:	8d 40 08             	lea    0x8(%eax),%eax
  8007e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ef:	e9 e8 00 00 00       	jmp    8008dc <vprintfmt+0x3fa>
	else if (lflag)
  8007f4:	85 c9                	test   %ecx,%ecx
  8007f6:	75 1a                	jne    800812 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	8b 10                	mov    (%eax),%edx
  8007fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800802:	8d 40 04             	lea    0x4(%eax),%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800808:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080d:	e9 ca 00 00 00       	jmp    8008dc <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	8b 10                	mov    (%eax),%edx
  800817:	b9 00 00 00 00       	mov    $0x0,%ecx
  80081c:	8d 40 04             	lea    0x4(%eax),%eax
  80081f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800822:	b8 0a 00 00 00       	mov    $0xa,%eax
  800827:	e9 b0 00 00 00       	jmp    8008dc <vprintfmt+0x3fa>
	if (lflag >= 2)
  80082c:	83 f9 01             	cmp    $0x1,%ecx
  80082f:	7e 3c                	jle    80086d <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8b 50 04             	mov    0x4(%eax),%edx
  800837:	8b 00                	mov    (%eax),%eax
  800839:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	8d 40 08             	lea    0x8(%eax),%eax
  800845:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800848:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80084c:	79 59                	jns    8008a7 <vprintfmt+0x3c5>
                putch('-', putdat);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	53                   	push   %ebx
  800852:	6a 2d                	push   $0x2d
  800854:	ff d6                	call   *%esi
                num = -(long long) num;
  800856:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800859:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80085c:	f7 da                	neg    %edx
  80085e:	83 d1 00             	adc    $0x0,%ecx
  800861:	f7 d9                	neg    %ecx
  800863:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800866:	b8 08 00 00 00       	mov    $0x8,%eax
  80086b:	eb 6f                	jmp    8008dc <vprintfmt+0x3fa>
	else if (lflag)
  80086d:	85 c9                	test   %ecx,%ecx
  80086f:	75 1b                	jne    80088c <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800879:	89 c1                	mov    %eax,%ecx
  80087b:	c1 f9 1f             	sar    $0x1f,%ecx
  80087e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8d 40 04             	lea    0x4(%eax),%eax
  800887:	89 45 14             	mov    %eax,0x14(%ebp)
  80088a:	eb bc                	jmp    800848 <vprintfmt+0x366>
		return va_arg(*ap, long);
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800894:	89 c1                	mov    %eax,%ecx
  800896:	c1 f9 1f             	sar    $0x1f,%ecx
  800899:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8d 40 04             	lea    0x4(%eax),%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	eb a1                	jmp    800848 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8008a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8008ad:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b2:	eb 28                	jmp    8008dc <vprintfmt+0x3fa>
			putch('0', putdat);
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	53                   	push   %ebx
  8008b8:	6a 30                	push   $0x30
  8008ba:	ff d6                	call   *%esi
			putch('x', putdat);
  8008bc:	83 c4 08             	add    $0x8,%esp
  8008bf:	53                   	push   %ebx
  8008c0:	6a 78                	push   $0x78
  8008c2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	8b 10                	mov    (%eax),%edx
  8008c9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008ce:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008d1:	8d 40 04             	lea    0x4(%eax),%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008dc:	83 ec 0c             	sub    $0xc,%esp
  8008df:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008e3:	57                   	push   %edi
  8008e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8008e7:	50                   	push   %eax
  8008e8:	51                   	push   %ecx
  8008e9:	52                   	push   %edx
  8008ea:	89 da                	mov    %ebx,%edx
  8008ec:	89 f0                	mov    %esi,%eax
  8008ee:	e8 06 fb ff ff       	call   8003f9 <printnum>
			break;
  8008f3:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f9:	83 c7 01             	add    $0x1,%edi
  8008fc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800900:	83 f8 25             	cmp    $0x25,%eax
  800903:	0f 84 f0 fb ff ff    	je     8004f9 <vprintfmt+0x17>
			if (ch == '\0')
  800909:	85 c0                	test   %eax,%eax
  80090b:	0f 84 8b 00 00 00    	je     80099c <vprintfmt+0x4ba>
			putch(ch, putdat);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	53                   	push   %ebx
  800915:	50                   	push   %eax
  800916:	ff d6                	call   *%esi
  800918:	83 c4 10             	add    $0x10,%esp
  80091b:	eb dc                	jmp    8008f9 <vprintfmt+0x417>
	if (lflag >= 2)
  80091d:	83 f9 01             	cmp    $0x1,%ecx
  800920:	7e 15                	jle    800937 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	8b 10                	mov    (%eax),%edx
  800927:	8b 48 04             	mov    0x4(%eax),%ecx
  80092a:	8d 40 08             	lea    0x8(%eax),%eax
  80092d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800930:	b8 10 00 00 00       	mov    $0x10,%eax
  800935:	eb a5                	jmp    8008dc <vprintfmt+0x3fa>
	else if (lflag)
  800937:	85 c9                	test   %ecx,%ecx
  800939:	75 17                	jne    800952 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	8b 10                	mov    (%eax),%edx
  800940:	b9 00 00 00 00       	mov    $0x0,%ecx
  800945:	8d 40 04             	lea    0x4(%eax),%eax
  800948:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80094b:	b8 10 00 00 00       	mov    $0x10,%eax
  800950:	eb 8a                	jmp    8008dc <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800952:	8b 45 14             	mov    0x14(%ebp),%eax
  800955:	8b 10                	mov    (%eax),%edx
  800957:	b9 00 00 00 00       	mov    $0x0,%ecx
  80095c:	8d 40 04             	lea    0x4(%eax),%eax
  80095f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800962:	b8 10 00 00 00       	mov    $0x10,%eax
  800967:	e9 70 ff ff ff       	jmp    8008dc <vprintfmt+0x3fa>
			putch(ch, putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	53                   	push   %ebx
  800970:	6a 25                	push   $0x25
  800972:	ff d6                	call   *%esi
			break;
  800974:	83 c4 10             	add    $0x10,%esp
  800977:	e9 7a ff ff ff       	jmp    8008f6 <vprintfmt+0x414>
			putch('%', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	53                   	push   %ebx
  800980:	6a 25                	push   $0x25
  800982:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800984:	83 c4 10             	add    $0x10,%esp
  800987:	89 f8                	mov    %edi,%eax
  800989:	eb 03                	jmp    80098e <vprintfmt+0x4ac>
  80098b:	83 e8 01             	sub    $0x1,%eax
  80098e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800992:	75 f7                	jne    80098b <vprintfmt+0x4a9>
  800994:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800997:	e9 5a ff ff ff       	jmp    8008f6 <vprintfmt+0x414>
}
  80099c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80099f:	5b                   	pop    %ebx
  8009a0:	5e                   	pop    %esi
  8009a1:	5f                   	pop    %edi
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	83 ec 18             	sub    $0x18,%esp
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009b3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009b7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c1:	85 c0                	test   %eax,%eax
  8009c3:	74 26                	je     8009eb <vsnprintf+0x47>
  8009c5:	85 d2                	test   %edx,%edx
  8009c7:	7e 22                	jle    8009eb <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009c9:	ff 75 14             	pushl  0x14(%ebp)
  8009cc:	ff 75 10             	pushl  0x10(%ebp)
  8009cf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009d2:	50                   	push   %eax
  8009d3:	68 a8 04 80 00       	push   $0x8004a8
  8009d8:	e8 05 fb ff ff       	call   8004e2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e6:	83 c4 10             	add    $0x10,%esp
}
  8009e9:	c9                   	leave  
  8009ea:	c3                   	ret    
		return -E_INVAL;
  8009eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f0:	eb f7                	jmp    8009e9 <vsnprintf+0x45>

008009f2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009fb:	50                   	push   %eax
  8009fc:	ff 75 10             	pushl  0x10(%ebp)
  8009ff:	ff 75 0c             	pushl  0xc(%ebp)
  800a02:	ff 75 08             	pushl  0x8(%ebp)
  800a05:	e8 9a ff ff ff       	call   8009a4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a12:	b8 00 00 00 00       	mov    $0x0,%eax
  800a17:	eb 03                	jmp    800a1c <strlen+0x10>
		n++;
  800a19:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a1c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a20:	75 f7                	jne    800a19 <strlen+0xd>
	return n;
}
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a32:	eb 03                	jmp    800a37 <strnlen+0x13>
		n++;
  800a34:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a37:	39 d0                	cmp    %edx,%eax
  800a39:	74 06                	je     800a41 <strnlen+0x1d>
  800a3b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a3f:	75 f3                	jne    800a34 <strnlen+0x10>
	return n;
}
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	53                   	push   %ebx
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	83 c1 01             	add    $0x1,%ecx
  800a52:	83 c2 01             	add    $0x1,%edx
  800a55:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a59:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a5c:	84 db                	test   %bl,%bl
  800a5e:	75 ef                	jne    800a4f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a60:	5b                   	pop    %ebx
  800a61:	5d                   	pop    %ebp
  800a62:	c3                   	ret    

00800a63 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	53                   	push   %ebx
  800a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a6a:	53                   	push   %ebx
  800a6b:	e8 9c ff ff ff       	call   800a0c <strlen>
  800a70:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	01 d8                	add    %ebx,%eax
  800a78:	50                   	push   %eax
  800a79:	e8 c5 ff ff ff       	call   800a43 <strcpy>
	return dst;
}
  800a7e:	89 d8                	mov    %ebx,%eax
  800a80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    

00800a85 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	56                   	push   %esi
  800a89:	53                   	push   %ebx
  800a8a:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a90:	89 f3                	mov    %esi,%ebx
  800a92:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a95:	89 f2                	mov    %esi,%edx
  800a97:	eb 0f                	jmp    800aa8 <strncpy+0x23>
		*dst++ = *src;
  800a99:	83 c2 01             	add    $0x1,%edx
  800a9c:	0f b6 01             	movzbl (%ecx),%eax
  800a9f:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa2:	80 39 01             	cmpb   $0x1,(%ecx)
  800aa5:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800aa8:	39 da                	cmp    %ebx,%edx
  800aaa:	75 ed                	jne    800a99 <strncpy+0x14>
	}
	return ret;
}
  800aac:	89 f0                	mov    %esi,%eax
  800aae:	5b                   	pop    %ebx
  800aaf:	5e                   	pop    %esi
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	56                   	push   %esi
  800ab6:	53                   	push   %ebx
  800ab7:	8b 75 08             	mov    0x8(%ebp),%esi
  800aba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ac0:	89 f0                	mov    %esi,%eax
  800ac2:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac6:	85 c9                	test   %ecx,%ecx
  800ac8:	75 0b                	jne    800ad5 <strlcpy+0x23>
  800aca:	eb 17                	jmp    800ae3 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800acc:	83 c2 01             	add    $0x1,%edx
  800acf:	83 c0 01             	add    $0x1,%eax
  800ad2:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ad5:	39 d8                	cmp    %ebx,%eax
  800ad7:	74 07                	je     800ae0 <strlcpy+0x2e>
  800ad9:	0f b6 0a             	movzbl (%edx),%ecx
  800adc:	84 c9                	test   %cl,%cl
  800ade:	75 ec                	jne    800acc <strlcpy+0x1a>
		*dst = '\0';
  800ae0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae3:	29 f0                	sub    %esi,%eax
}
  800ae5:	5b                   	pop    %ebx
  800ae6:	5e                   	pop    %esi
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af2:	eb 06                	jmp    800afa <strcmp+0x11>
		p++, q++;
  800af4:	83 c1 01             	add    $0x1,%ecx
  800af7:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800afa:	0f b6 01             	movzbl (%ecx),%eax
  800afd:	84 c0                	test   %al,%al
  800aff:	74 04                	je     800b05 <strcmp+0x1c>
  800b01:	3a 02                	cmp    (%edx),%al
  800b03:	74 ef                	je     800af4 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b05:	0f b6 c0             	movzbl %al,%eax
  800b08:	0f b6 12             	movzbl (%edx),%edx
  800b0b:	29 d0                	sub    %edx,%eax
}
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	53                   	push   %ebx
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b19:	89 c3                	mov    %eax,%ebx
  800b1b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b1e:	eb 06                	jmp    800b26 <strncmp+0x17>
		n--, p++, q++;
  800b20:	83 c0 01             	add    $0x1,%eax
  800b23:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b26:	39 d8                	cmp    %ebx,%eax
  800b28:	74 16                	je     800b40 <strncmp+0x31>
  800b2a:	0f b6 08             	movzbl (%eax),%ecx
  800b2d:	84 c9                	test   %cl,%cl
  800b2f:	74 04                	je     800b35 <strncmp+0x26>
  800b31:	3a 0a                	cmp    (%edx),%cl
  800b33:	74 eb                	je     800b20 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b35:	0f b6 00             	movzbl (%eax),%eax
  800b38:	0f b6 12             	movzbl (%edx),%edx
  800b3b:	29 d0                	sub    %edx,%eax
}
  800b3d:	5b                   	pop    %ebx
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    
		return 0;
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
  800b45:	eb f6                	jmp    800b3d <strncmp+0x2e>

00800b47 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b51:	0f b6 10             	movzbl (%eax),%edx
  800b54:	84 d2                	test   %dl,%dl
  800b56:	74 09                	je     800b61 <strchr+0x1a>
		if (*s == c)
  800b58:	38 ca                	cmp    %cl,%dl
  800b5a:	74 0a                	je     800b66 <strchr+0x1f>
	for (; *s; s++)
  800b5c:	83 c0 01             	add    $0x1,%eax
  800b5f:	eb f0                	jmp    800b51 <strchr+0xa>
			return (char *) s;
	return 0;
  800b61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b72:	eb 03                	jmp    800b77 <strfind+0xf>
  800b74:	83 c0 01             	add    $0x1,%eax
  800b77:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b7a:	38 ca                	cmp    %cl,%dl
  800b7c:	74 04                	je     800b82 <strfind+0x1a>
  800b7e:	84 d2                	test   %dl,%dl
  800b80:	75 f2                	jne    800b74 <strfind+0xc>
			break;
	return (char *) s;
}
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
  800b8a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b90:	85 c9                	test   %ecx,%ecx
  800b92:	74 13                	je     800ba7 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b94:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b9a:	75 05                	jne    800ba1 <memset+0x1d>
  800b9c:	f6 c1 03             	test   $0x3,%cl
  800b9f:	74 0d                	je     800bae <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	fc                   	cld    
  800ba5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ba7:	89 f8                	mov    %edi,%eax
  800ba9:	5b                   	pop    %ebx
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    
		c &= 0xFF;
  800bae:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb2:	89 d3                	mov    %edx,%ebx
  800bb4:	c1 e3 08             	shl    $0x8,%ebx
  800bb7:	89 d0                	mov    %edx,%eax
  800bb9:	c1 e0 18             	shl    $0x18,%eax
  800bbc:	89 d6                	mov    %edx,%esi
  800bbe:	c1 e6 10             	shl    $0x10,%esi
  800bc1:	09 f0                	or     %esi,%eax
  800bc3:	09 c2                	or     %eax,%edx
  800bc5:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bc7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bca:	89 d0                	mov    %edx,%eax
  800bcc:	fc                   	cld    
  800bcd:	f3 ab                	rep stos %eax,%es:(%edi)
  800bcf:	eb d6                	jmp    800ba7 <memset+0x23>

00800bd1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	57                   	push   %edi
  800bd5:	56                   	push   %esi
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bdc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bdf:	39 c6                	cmp    %eax,%esi
  800be1:	73 35                	jae    800c18 <memmove+0x47>
  800be3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800be6:	39 c2                	cmp    %eax,%edx
  800be8:	76 2e                	jbe    800c18 <memmove+0x47>
		s += n;
		d += n;
  800bea:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bed:	89 d6                	mov    %edx,%esi
  800bef:	09 fe                	or     %edi,%esi
  800bf1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bf7:	74 0c                	je     800c05 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bf9:	83 ef 01             	sub    $0x1,%edi
  800bfc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bff:	fd                   	std    
  800c00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c02:	fc                   	cld    
  800c03:	eb 21                	jmp    800c26 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c05:	f6 c1 03             	test   $0x3,%cl
  800c08:	75 ef                	jne    800bf9 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c0a:	83 ef 04             	sub    $0x4,%edi
  800c0d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c10:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c13:	fd                   	std    
  800c14:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c16:	eb ea                	jmp    800c02 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c18:	89 f2                	mov    %esi,%edx
  800c1a:	09 c2                	or     %eax,%edx
  800c1c:	f6 c2 03             	test   $0x3,%dl
  800c1f:	74 09                	je     800c2a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c21:	89 c7                	mov    %eax,%edi
  800c23:	fc                   	cld    
  800c24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c26:	5e                   	pop    %esi
  800c27:	5f                   	pop    %edi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2a:	f6 c1 03             	test   $0x3,%cl
  800c2d:	75 f2                	jne    800c21 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c2f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c32:	89 c7                	mov    %eax,%edi
  800c34:	fc                   	cld    
  800c35:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c37:	eb ed                	jmp    800c26 <memmove+0x55>

00800c39 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c3c:	ff 75 10             	pushl  0x10(%ebp)
  800c3f:	ff 75 0c             	pushl  0xc(%ebp)
  800c42:	ff 75 08             	pushl  0x8(%ebp)
  800c45:	e8 87 ff ff ff       	call   800bd1 <memmove>
}
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c57:	89 c6                	mov    %eax,%esi
  800c59:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c5c:	39 f0                	cmp    %esi,%eax
  800c5e:	74 1c                	je     800c7c <memcmp+0x30>
		if (*s1 != *s2)
  800c60:	0f b6 08             	movzbl (%eax),%ecx
  800c63:	0f b6 1a             	movzbl (%edx),%ebx
  800c66:	38 d9                	cmp    %bl,%cl
  800c68:	75 08                	jne    800c72 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c6a:	83 c0 01             	add    $0x1,%eax
  800c6d:	83 c2 01             	add    $0x1,%edx
  800c70:	eb ea                	jmp    800c5c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c72:	0f b6 c1             	movzbl %cl,%eax
  800c75:	0f b6 db             	movzbl %bl,%ebx
  800c78:	29 d8                	sub    %ebx,%eax
  800c7a:	eb 05                	jmp    800c81 <memcmp+0x35>
	}

	return 0;
  800c7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c8e:	89 c2                	mov    %eax,%edx
  800c90:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c93:	39 d0                	cmp    %edx,%eax
  800c95:	73 09                	jae    800ca0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c97:	38 08                	cmp    %cl,(%eax)
  800c99:	74 05                	je     800ca0 <memfind+0x1b>
	for (; s < ends; s++)
  800c9b:	83 c0 01             	add    $0x1,%eax
  800c9e:	eb f3                	jmp    800c93 <memfind+0xe>
			break;
	return (void *) s;
}
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	57                   	push   %edi
  800ca6:	56                   	push   %esi
  800ca7:	53                   	push   %ebx
  800ca8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cae:	eb 03                	jmp    800cb3 <strtol+0x11>
		s++;
  800cb0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cb3:	0f b6 01             	movzbl (%ecx),%eax
  800cb6:	3c 20                	cmp    $0x20,%al
  800cb8:	74 f6                	je     800cb0 <strtol+0xe>
  800cba:	3c 09                	cmp    $0x9,%al
  800cbc:	74 f2                	je     800cb0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cbe:	3c 2b                	cmp    $0x2b,%al
  800cc0:	74 2e                	je     800cf0 <strtol+0x4e>
	int neg = 0;
  800cc2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cc7:	3c 2d                	cmp    $0x2d,%al
  800cc9:	74 2f                	je     800cfa <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ccb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cd1:	75 05                	jne    800cd8 <strtol+0x36>
  800cd3:	80 39 30             	cmpb   $0x30,(%ecx)
  800cd6:	74 2c                	je     800d04 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cd8:	85 db                	test   %ebx,%ebx
  800cda:	75 0a                	jne    800ce6 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cdc:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ce1:	80 39 30             	cmpb   $0x30,(%ecx)
  800ce4:	74 28                	je     800d0e <strtol+0x6c>
		base = 10;
  800ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ceb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cee:	eb 50                	jmp    800d40 <strtol+0x9e>
		s++;
  800cf0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cf3:	bf 00 00 00 00       	mov    $0x0,%edi
  800cf8:	eb d1                	jmp    800ccb <strtol+0x29>
		s++, neg = 1;
  800cfa:	83 c1 01             	add    $0x1,%ecx
  800cfd:	bf 01 00 00 00       	mov    $0x1,%edi
  800d02:	eb c7                	jmp    800ccb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d04:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d08:	74 0e                	je     800d18 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d0a:	85 db                	test   %ebx,%ebx
  800d0c:	75 d8                	jne    800ce6 <strtol+0x44>
		s++, base = 8;
  800d0e:	83 c1 01             	add    $0x1,%ecx
  800d11:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d16:	eb ce                	jmp    800ce6 <strtol+0x44>
		s += 2, base = 16;
  800d18:	83 c1 02             	add    $0x2,%ecx
  800d1b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d20:	eb c4                	jmp    800ce6 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d22:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d25:	89 f3                	mov    %esi,%ebx
  800d27:	80 fb 19             	cmp    $0x19,%bl
  800d2a:	77 29                	ja     800d55 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d2c:	0f be d2             	movsbl %dl,%edx
  800d2f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d32:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d35:	7d 30                	jge    800d67 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d37:	83 c1 01             	add    $0x1,%ecx
  800d3a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d3e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d40:	0f b6 11             	movzbl (%ecx),%edx
  800d43:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d46:	89 f3                	mov    %esi,%ebx
  800d48:	80 fb 09             	cmp    $0x9,%bl
  800d4b:	77 d5                	ja     800d22 <strtol+0x80>
			dig = *s - '0';
  800d4d:	0f be d2             	movsbl %dl,%edx
  800d50:	83 ea 30             	sub    $0x30,%edx
  800d53:	eb dd                	jmp    800d32 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d55:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d58:	89 f3                	mov    %esi,%ebx
  800d5a:	80 fb 19             	cmp    $0x19,%bl
  800d5d:	77 08                	ja     800d67 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d5f:	0f be d2             	movsbl %dl,%edx
  800d62:	83 ea 37             	sub    $0x37,%edx
  800d65:	eb cb                	jmp    800d32 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6b:	74 05                	je     800d72 <strtol+0xd0>
		*endptr = (char *) s;
  800d6d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d70:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d72:	89 c2                	mov    %eax,%edx
  800d74:	f7 da                	neg    %edx
  800d76:	85 ff                	test   %edi,%edi
  800d78:	0f 45 c2             	cmovne %edx,%eax
}
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <__udivdi3>:
  800d80:	55                   	push   %ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 1c             	sub    $0x1c,%esp
  800d87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800d8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800d8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800d93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800d97:	85 d2                	test   %edx,%edx
  800d99:	75 35                	jne    800dd0 <__udivdi3+0x50>
  800d9b:	39 f3                	cmp    %esi,%ebx
  800d9d:	0f 87 bd 00 00 00    	ja     800e60 <__udivdi3+0xe0>
  800da3:	85 db                	test   %ebx,%ebx
  800da5:	89 d9                	mov    %ebx,%ecx
  800da7:	75 0b                	jne    800db4 <__udivdi3+0x34>
  800da9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dae:	31 d2                	xor    %edx,%edx
  800db0:	f7 f3                	div    %ebx
  800db2:	89 c1                	mov    %eax,%ecx
  800db4:	31 d2                	xor    %edx,%edx
  800db6:	89 f0                	mov    %esi,%eax
  800db8:	f7 f1                	div    %ecx
  800dba:	89 c6                	mov    %eax,%esi
  800dbc:	89 e8                	mov    %ebp,%eax
  800dbe:	89 f7                	mov    %esi,%edi
  800dc0:	f7 f1                	div    %ecx
  800dc2:	89 fa                	mov    %edi,%edx
  800dc4:	83 c4 1c             	add    $0x1c,%esp
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    
  800dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800dd0:	39 f2                	cmp    %esi,%edx
  800dd2:	77 7c                	ja     800e50 <__udivdi3+0xd0>
  800dd4:	0f bd fa             	bsr    %edx,%edi
  800dd7:	83 f7 1f             	xor    $0x1f,%edi
  800dda:	0f 84 98 00 00 00    	je     800e78 <__udivdi3+0xf8>
  800de0:	89 f9                	mov    %edi,%ecx
  800de2:	b8 20 00 00 00       	mov    $0x20,%eax
  800de7:	29 f8                	sub    %edi,%eax
  800de9:	d3 e2                	shl    %cl,%edx
  800deb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800def:	89 c1                	mov    %eax,%ecx
  800df1:	89 da                	mov    %ebx,%edx
  800df3:	d3 ea                	shr    %cl,%edx
  800df5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800df9:	09 d1                	or     %edx,%ecx
  800dfb:	89 f2                	mov    %esi,%edx
  800dfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e01:	89 f9                	mov    %edi,%ecx
  800e03:	d3 e3                	shl    %cl,%ebx
  800e05:	89 c1                	mov    %eax,%ecx
  800e07:	d3 ea                	shr    %cl,%edx
  800e09:	89 f9                	mov    %edi,%ecx
  800e0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e0f:	d3 e6                	shl    %cl,%esi
  800e11:	89 eb                	mov    %ebp,%ebx
  800e13:	89 c1                	mov    %eax,%ecx
  800e15:	d3 eb                	shr    %cl,%ebx
  800e17:	09 de                	or     %ebx,%esi
  800e19:	89 f0                	mov    %esi,%eax
  800e1b:	f7 74 24 08          	divl   0x8(%esp)
  800e1f:	89 d6                	mov    %edx,%esi
  800e21:	89 c3                	mov    %eax,%ebx
  800e23:	f7 64 24 0c          	mull   0xc(%esp)
  800e27:	39 d6                	cmp    %edx,%esi
  800e29:	72 0c                	jb     800e37 <__udivdi3+0xb7>
  800e2b:	89 f9                	mov    %edi,%ecx
  800e2d:	d3 e5                	shl    %cl,%ebp
  800e2f:	39 c5                	cmp    %eax,%ebp
  800e31:	73 5d                	jae    800e90 <__udivdi3+0x110>
  800e33:	39 d6                	cmp    %edx,%esi
  800e35:	75 59                	jne    800e90 <__udivdi3+0x110>
  800e37:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e3a:	31 ff                	xor    %edi,%edi
  800e3c:	89 fa                	mov    %edi,%edx
  800e3e:	83 c4 1c             	add    $0x1c,%esp
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    
  800e46:	8d 76 00             	lea    0x0(%esi),%esi
  800e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800e50:	31 ff                	xor    %edi,%edi
  800e52:	31 c0                	xor    %eax,%eax
  800e54:	89 fa                	mov    %edi,%edx
  800e56:	83 c4 1c             	add    $0x1c,%esp
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    
  800e5e:	66 90                	xchg   %ax,%ax
  800e60:	31 ff                	xor    %edi,%edi
  800e62:	89 e8                	mov    %ebp,%eax
  800e64:	89 f2                	mov    %esi,%edx
  800e66:	f7 f3                	div    %ebx
  800e68:	89 fa                	mov    %edi,%edx
  800e6a:	83 c4 1c             	add    $0x1c,%esp
  800e6d:	5b                   	pop    %ebx
  800e6e:	5e                   	pop    %esi
  800e6f:	5f                   	pop    %edi
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    
  800e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e78:	39 f2                	cmp    %esi,%edx
  800e7a:	72 06                	jb     800e82 <__udivdi3+0x102>
  800e7c:	31 c0                	xor    %eax,%eax
  800e7e:	39 eb                	cmp    %ebp,%ebx
  800e80:	77 d2                	ja     800e54 <__udivdi3+0xd4>
  800e82:	b8 01 00 00 00       	mov    $0x1,%eax
  800e87:	eb cb                	jmp    800e54 <__udivdi3+0xd4>
  800e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e90:	89 d8                	mov    %ebx,%eax
  800e92:	31 ff                	xor    %edi,%edi
  800e94:	eb be                	jmp    800e54 <__udivdi3+0xd4>
  800e96:	66 90                	xchg   %ax,%ax
  800e98:	66 90                	xchg   %ax,%ax
  800e9a:	66 90                	xchg   %ax,%ax
  800e9c:	66 90                	xchg   %ax,%ax
  800e9e:	66 90                	xchg   %ax,%ax

00800ea0 <__umoddi3>:
  800ea0:	55                   	push   %ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	83 ec 1c             	sub    $0x1c,%esp
  800ea7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800eab:	8b 74 24 30          	mov    0x30(%esp),%esi
  800eaf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800eb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800eb7:	85 ed                	test   %ebp,%ebp
  800eb9:	89 f0                	mov    %esi,%eax
  800ebb:	89 da                	mov    %ebx,%edx
  800ebd:	75 19                	jne    800ed8 <__umoddi3+0x38>
  800ebf:	39 df                	cmp    %ebx,%edi
  800ec1:	0f 86 b1 00 00 00    	jbe    800f78 <__umoddi3+0xd8>
  800ec7:	f7 f7                	div    %edi
  800ec9:	89 d0                	mov    %edx,%eax
  800ecb:	31 d2                	xor    %edx,%edx
  800ecd:	83 c4 1c             	add    $0x1c,%esp
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    
  800ed5:	8d 76 00             	lea    0x0(%esi),%esi
  800ed8:	39 dd                	cmp    %ebx,%ebp
  800eda:	77 f1                	ja     800ecd <__umoddi3+0x2d>
  800edc:	0f bd cd             	bsr    %ebp,%ecx
  800edf:	83 f1 1f             	xor    $0x1f,%ecx
  800ee2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ee6:	0f 84 b4 00 00 00    	je     800fa0 <__umoddi3+0x100>
  800eec:	b8 20 00 00 00       	mov    $0x20,%eax
  800ef1:	89 c2                	mov    %eax,%edx
  800ef3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 c1                	mov    %eax,%ecx
  800efb:	89 f8                	mov    %edi,%eax
  800efd:	d3 e5                	shl    %cl,%ebp
  800eff:	89 d1                	mov    %edx,%ecx
  800f01:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f05:	d3 e8                	shr    %cl,%eax
  800f07:	09 c5                	or     %eax,%ebp
  800f09:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f0d:	89 c1                	mov    %eax,%ecx
  800f0f:	d3 e7                	shl    %cl,%edi
  800f11:	89 d1                	mov    %edx,%ecx
  800f13:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f17:	89 df                	mov    %ebx,%edi
  800f19:	d3 ef                	shr    %cl,%edi
  800f1b:	89 c1                	mov    %eax,%ecx
  800f1d:	89 f0                	mov    %esi,%eax
  800f1f:	d3 e3                	shl    %cl,%ebx
  800f21:	89 d1                	mov    %edx,%ecx
  800f23:	89 fa                	mov    %edi,%edx
  800f25:	d3 e8                	shr    %cl,%eax
  800f27:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f2c:	09 d8                	or     %ebx,%eax
  800f2e:	f7 f5                	div    %ebp
  800f30:	d3 e6                	shl    %cl,%esi
  800f32:	89 d1                	mov    %edx,%ecx
  800f34:	f7 64 24 08          	mull   0x8(%esp)
  800f38:	39 d1                	cmp    %edx,%ecx
  800f3a:	89 c3                	mov    %eax,%ebx
  800f3c:	89 d7                	mov    %edx,%edi
  800f3e:	72 06                	jb     800f46 <__umoddi3+0xa6>
  800f40:	75 0e                	jne    800f50 <__umoddi3+0xb0>
  800f42:	39 c6                	cmp    %eax,%esi
  800f44:	73 0a                	jae    800f50 <__umoddi3+0xb0>
  800f46:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f4a:	19 ea                	sbb    %ebp,%edx
  800f4c:	89 d7                	mov    %edx,%edi
  800f4e:	89 c3                	mov    %eax,%ebx
  800f50:	89 ca                	mov    %ecx,%edx
  800f52:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f57:	29 de                	sub    %ebx,%esi
  800f59:	19 fa                	sbb    %edi,%edx
  800f5b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800f5f:	89 d0                	mov    %edx,%eax
  800f61:	d3 e0                	shl    %cl,%eax
  800f63:	89 d9                	mov    %ebx,%ecx
  800f65:	d3 ee                	shr    %cl,%esi
  800f67:	d3 ea                	shr    %cl,%edx
  800f69:	09 f0                	or     %esi,%eax
  800f6b:	83 c4 1c             	add    $0x1c,%esp
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    
  800f73:	90                   	nop
  800f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f78:	85 ff                	test   %edi,%edi
  800f7a:	89 f9                	mov    %edi,%ecx
  800f7c:	75 0b                	jne    800f89 <__umoddi3+0xe9>
  800f7e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f83:	31 d2                	xor    %edx,%edx
  800f85:	f7 f7                	div    %edi
  800f87:	89 c1                	mov    %eax,%ecx
  800f89:	89 d8                	mov    %ebx,%eax
  800f8b:	31 d2                	xor    %edx,%edx
  800f8d:	f7 f1                	div    %ecx
  800f8f:	89 f0                	mov    %esi,%eax
  800f91:	f7 f1                	div    %ecx
  800f93:	e9 31 ff ff ff       	jmp    800ec9 <__umoddi3+0x29>
  800f98:	90                   	nop
  800f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fa0:	39 dd                	cmp    %ebx,%ebp
  800fa2:	72 08                	jb     800fac <__umoddi3+0x10c>
  800fa4:	39 f7                	cmp    %esi,%edi
  800fa6:	0f 87 21 ff ff ff    	ja     800ecd <__umoddi3+0x2d>
  800fac:	89 da                	mov    %ebx,%edx
  800fae:	89 f0                	mov    %esi,%eax
  800fb0:	29 f8                	sub    %edi,%eax
  800fb2:	19 ea                	sbb    %ebp,%edx
  800fb4:	e9 14 ff ff ff       	jmp    800ecd <__umoddi3+0x2d>
