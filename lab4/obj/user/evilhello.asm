
obj/user/evilhello：     文件格式 elf32-i386


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

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800039:	6a 64                	push   $0x64
  80003b:	68 0c 00 10 f0       	push   $0xf010000c
  800040:	e8 4d 00 00 00       	call   800092 <sys_cputs>
}
  800045:	83 c4 10             	add    $0x10,%esp
  800048:	c9                   	leave  
  800049:	c3                   	ret    

0080004a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	83 ec 08             	sub    $0x8,%esp
  800050:	8b 45 08             	mov    0x8(%ebp),%eax
  800053:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800056:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  80005d:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800060:	85 c0                	test   %eax,%eax
  800062:	7e 08                	jle    80006c <libmain+0x22>
		binaryname = argv[0];
  800064:	8b 0a                	mov    (%edx),%ecx
  800066:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  80006c:	83 ec 08             	sub    $0x8,%esp
  80006f:	52                   	push   %edx
  800070:	50                   	push   %eax
  800071:	e8 bd ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800076:	e8 05 00 00 00       	call   800080 <exit>
}
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	c9                   	leave  
  80007f:	c3                   	ret    

00800080 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800086:	6a 00                	push   $0x0
  800088:	e8 42 00 00 00       	call   8000cf <sys_env_destroy>
}
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	c9                   	leave  
  800091:	c3                   	ret    

00800092 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	57                   	push   %edi
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
    asm volatile("int %1\n"
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a3:	89 c3                	mov    %eax,%ebx
  8000a5:	89 c7                	mov    %eax,%edi
  8000a7:	89 c6                	mov    %eax,%esi
  8000a9:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000ab:	5b                   	pop    %ebx
  8000ac:	5e                   	pop    %esi
  8000ad:	5f                   	pop    %edi
  8000ae:	5d                   	pop    %ebp
  8000af:	c3                   	ret    

008000b0 <sys_cgetc>:

int
sys_cgetc(void) {
  8000b0:	55                   	push   %ebp
  8000b1:	89 e5                	mov    %esp,%ebp
  8000b3:	57                   	push   %edi
  8000b4:	56                   	push   %esi
  8000b5:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c0:	89 d1                	mov    %edx,%ecx
  8000c2:	89 d3                	mov    %edx,%ebx
  8000c4:	89 d7                	mov    %edx,%edi
  8000c6:	89 d6                	mov    %edx,%esi
  8000c8:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ca:	5b                   	pop    %ebx
  8000cb:	5e                   	pop    %esi
  8000cc:	5f                   	pop    %edi
  8000cd:	5d                   	pop    %ebp
  8000ce:	c3                   	ret    

008000cf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000cf:	55                   	push   %ebp
  8000d0:	89 e5                	mov    %esp,%ebp
  8000d2:	57                   	push   %edi
  8000d3:	56                   	push   %esi
  8000d4:	53                   	push   %ebx
  8000d5:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e0:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e5:	89 cb                	mov    %ecx,%ebx
  8000e7:	89 cf                	mov    %ecx,%edi
  8000e9:	89 ce                	mov    %ecx,%esi
  8000eb:	cd 30                	int    $0x30
    if (check && ret > 0)
  8000ed:	85 c0                	test   %eax,%eax
  8000ef:	7f 08                	jg     8000f9 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f4:	5b                   	pop    %ebx
  8000f5:	5e                   	pop    %esi
  8000f6:	5f                   	pop    %edi
  8000f7:	5d                   	pop    %ebp
  8000f8:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8000f9:	83 ec 0c             	sub    $0xc,%esp
  8000fc:	50                   	push   %eax
  8000fd:	6a 03                	push   $0x3
  8000ff:	68 ca 0f 80 00       	push   $0x800fca
  800104:	6a 24                	push   $0x24
  800106:	68 e7 0f 80 00       	push   $0x800fe7
  80010b:	e8 ed 01 00 00       	call   8002fd <_panic>

00800110 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	57                   	push   %edi
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
    asm volatile("int %1\n"
  800116:	ba 00 00 00 00       	mov    $0x0,%edx
  80011b:	b8 02 00 00 00       	mov    $0x2,%eax
  800120:	89 d1                	mov    %edx,%ecx
  800122:	89 d3                	mov    %edx,%ebx
  800124:	89 d7                	mov    %edx,%edi
  800126:	89 d6                	mov    %edx,%esi
  800128:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5f                   	pop    %edi
  80012d:	5d                   	pop    %ebp
  80012e:	c3                   	ret    

0080012f <sys_yield>:

void
sys_yield(void)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	57                   	push   %edi
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
    asm volatile("int %1\n"
  800135:	ba 00 00 00 00       	mov    $0x0,%edx
  80013a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80013f:	89 d1                	mov    %edx,%ecx
  800141:	89 d3                	mov    %edx,%ebx
  800143:	89 d7                	mov    %edx,%edi
  800145:	89 d6                	mov    %edx,%esi
  800147:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800149:	5b                   	pop    %ebx
  80014a:	5e                   	pop    %esi
  80014b:	5f                   	pop    %edi
  80014c:	5d                   	pop    %ebp
  80014d:	c3                   	ret    

0080014e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	57                   	push   %edi
  800152:	56                   	push   %esi
  800153:	53                   	push   %ebx
  800154:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800157:	be 00 00 00 00       	mov    $0x0,%esi
  80015c:	8b 55 08             	mov    0x8(%ebp),%edx
  80015f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800162:	b8 04 00 00 00       	mov    $0x4,%eax
  800167:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80016a:	89 f7                	mov    %esi,%edi
  80016c:	cd 30                	int    $0x30
    if (check && ret > 0)
  80016e:	85 c0                	test   %eax,%eax
  800170:	7f 08                	jg     80017a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800172:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800175:	5b                   	pop    %ebx
  800176:	5e                   	pop    %esi
  800177:	5f                   	pop    %edi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80017a:	83 ec 0c             	sub    $0xc,%esp
  80017d:	50                   	push   %eax
  80017e:	6a 04                	push   $0x4
  800180:	68 ca 0f 80 00       	push   $0x800fca
  800185:	6a 24                	push   $0x24
  800187:	68 e7 0f 80 00       	push   $0x800fe7
  80018c:	e8 6c 01 00 00       	call   8002fd <_panic>

00800191 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	57                   	push   %edi
  800195:	56                   	push   %esi
  800196:	53                   	push   %ebx
  800197:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80019a:	8b 55 08             	mov    0x8(%ebp),%edx
  80019d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ab:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ae:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001b0:	85 c0                	test   %eax,%eax
  8001b2:	7f 08                	jg     8001bc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b7:	5b                   	pop    %ebx
  8001b8:	5e                   	pop    %esi
  8001b9:	5f                   	pop    %edi
  8001ba:	5d                   	pop    %ebp
  8001bb:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	50                   	push   %eax
  8001c0:	6a 05                	push   $0x5
  8001c2:	68 ca 0f 80 00       	push   $0x800fca
  8001c7:	6a 24                	push   $0x24
  8001c9:	68 e7 0f 80 00       	push   $0x800fe7
  8001ce:	e8 2a 01 00 00       	call   8002fd <_panic>

008001d3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	57                   	push   %edi
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e7:	b8 06 00 00 00       	mov    $0x6,%eax
  8001ec:	89 df                	mov    %ebx,%edi
  8001ee:	89 de                	mov    %ebx,%esi
  8001f0:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001f2:	85 c0                	test   %eax,%eax
  8001f4:	7f 08                	jg     8001fe <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f9:	5b                   	pop    %ebx
  8001fa:	5e                   	pop    %esi
  8001fb:	5f                   	pop    %edi
  8001fc:	5d                   	pop    %ebp
  8001fd:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	50                   	push   %eax
  800202:	6a 06                	push   $0x6
  800204:	68 ca 0f 80 00       	push   $0x800fca
  800209:	6a 24                	push   $0x24
  80020b:	68 e7 0f 80 00       	push   $0x800fe7
  800210:	e8 e8 00 00 00       	call   8002fd <_panic>

00800215 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	57                   	push   %edi
  800219:	56                   	push   %esi
  80021a:	53                   	push   %ebx
  80021b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80021e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800223:	8b 55 08             	mov    0x8(%ebp),%edx
  800226:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800229:	b8 08 00 00 00       	mov    $0x8,%eax
  80022e:	89 df                	mov    %ebx,%edi
  800230:	89 de                	mov    %ebx,%esi
  800232:	cd 30                	int    $0x30
    if (check && ret > 0)
  800234:	85 c0                	test   %eax,%eax
  800236:	7f 08                	jg     800240 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023b:	5b                   	pop    %ebx
  80023c:	5e                   	pop    %esi
  80023d:	5f                   	pop    %edi
  80023e:	5d                   	pop    %ebp
  80023f:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	50                   	push   %eax
  800244:	6a 08                	push   $0x8
  800246:	68 ca 0f 80 00       	push   $0x800fca
  80024b:	6a 24                	push   $0x24
  80024d:	68 e7 0f 80 00       	push   $0x800fe7
  800252:	e8 a6 00 00 00       	call   8002fd <_panic>

00800257 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	57                   	push   %edi
  80025b:	56                   	push   %esi
  80025c:	53                   	push   %ebx
  80025d:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800260:	bb 00 00 00 00       	mov    $0x0,%ebx
  800265:	8b 55 08             	mov    0x8(%ebp),%edx
  800268:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026b:	b8 09 00 00 00       	mov    $0x9,%eax
  800270:	89 df                	mov    %ebx,%edi
  800272:	89 de                	mov    %ebx,%esi
  800274:	cd 30                	int    $0x30
    if (check && ret > 0)
  800276:	85 c0                	test   %eax,%eax
  800278:	7f 08                	jg     800282 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80027a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027d:	5b                   	pop    %ebx
  80027e:	5e                   	pop    %esi
  80027f:	5f                   	pop    %edi
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	50                   	push   %eax
  800286:	6a 09                	push   $0x9
  800288:	68 ca 0f 80 00       	push   $0x800fca
  80028d:	6a 24                	push   $0x24
  80028f:	68 e7 0f 80 00       	push   $0x800fe7
  800294:	e8 64 00 00 00       	call   8002fd <_panic>

00800299 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	57                   	push   %edi
  80029d:	56                   	push   %esi
  80029e:	53                   	push   %ebx
    asm volatile("int %1\n"
  80029f:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a5:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002aa:	be 00 00 00 00       	mov    $0x0,%esi
  8002af:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002b2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002b5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002b7:	5b                   	pop    %ebx
  8002b8:	5e                   	pop    %esi
  8002b9:	5f                   	pop    %edi
  8002ba:	5d                   	pop    %ebp
  8002bb:	c3                   	ret    

008002bc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	57                   	push   %edi
  8002c0:	56                   	push   %esi
  8002c1:	53                   	push   %ebx
  8002c2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cd:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002d2:	89 cb                	mov    %ecx,%ebx
  8002d4:	89 cf                	mov    %ecx,%edi
  8002d6:	89 ce                	mov    %ecx,%esi
  8002d8:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	7f 08                	jg     8002e6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	50                   	push   %eax
  8002ea:	6a 0c                	push   $0xc
  8002ec:	68 ca 0f 80 00       	push   $0x800fca
  8002f1:	6a 24                	push   $0x24
  8002f3:	68 e7 0f 80 00       	push   $0x800fe7
  8002f8:	e8 00 00 00 00       	call   8002fd <_panic>

008002fd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	56                   	push   %esi
  800301:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800302:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800305:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80030b:	e8 00 fe ff ff       	call   800110 <sys_getenvid>
  800310:	83 ec 0c             	sub    $0xc,%esp
  800313:	ff 75 0c             	pushl  0xc(%ebp)
  800316:	ff 75 08             	pushl  0x8(%ebp)
  800319:	56                   	push   %esi
  80031a:	50                   	push   %eax
  80031b:	68 f8 0f 80 00       	push   $0x800ff8
  800320:	e8 b3 00 00 00       	call   8003d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800325:	83 c4 18             	add    $0x18,%esp
  800328:	53                   	push   %ebx
  800329:	ff 75 10             	pushl  0x10(%ebp)
  80032c:	e8 56 00 00 00       	call   800387 <vcprintf>
	cprintf("\n");
  800331:	c7 04 24 1c 10 80 00 	movl   $0x80101c,(%esp)
  800338:	e8 9b 00 00 00       	call   8003d8 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800340:	cc                   	int3   
  800341:	eb fd                	jmp    800340 <_panic+0x43>

00800343 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	53                   	push   %ebx
  800347:	83 ec 04             	sub    $0x4,%esp
  80034a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80034d:	8b 13                	mov    (%ebx),%edx
  80034f:	8d 42 01             	lea    0x1(%edx),%eax
  800352:	89 03                	mov    %eax,(%ebx)
  800354:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800357:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80035b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800360:	74 09                	je     80036b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800362:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800366:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800369:	c9                   	leave  
  80036a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80036b:	83 ec 08             	sub    $0x8,%esp
  80036e:	68 ff 00 00 00       	push   $0xff
  800373:	8d 43 08             	lea    0x8(%ebx),%eax
  800376:	50                   	push   %eax
  800377:	e8 16 fd ff ff       	call   800092 <sys_cputs>
		b->idx = 0;
  80037c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800382:	83 c4 10             	add    $0x10,%esp
  800385:	eb db                	jmp    800362 <putch+0x1f>

00800387 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800390:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800397:	00 00 00 
	b.cnt = 0;
  80039a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003a1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003a4:	ff 75 0c             	pushl  0xc(%ebp)
  8003a7:	ff 75 08             	pushl  0x8(%ebp)
  8003aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003b0:	50                   	push   %eax
  8003b1:	68 43 03 80 00       	push   $0x800343
  8003b6:	e8 1a 01 00 00       	call   8004d5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003bb:	83 c4 08             	add    $0x8,%esp
  8003be:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003c4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003ca:	50                   	push   %eax
  8003cb:	e8 c2 fc ff ff       	call   800092 <sys_cputs>

	return b.cnt;
}
  8003d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003de:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003e1:	50                   	push   %eax
  8003e2:	ff 75 08             	pushl  0x8(%ebp)
  8003e5:	e8 9d ff ff ff       	call   800387 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003ea:	c9                   	leave  
  8003eb:	c3                   	ret    

008003ec <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	57                   	push   %edi
  8003f0:	56                   	push   %esi
  8003f1:	53                   	push   %ebx
  8003f2:	83 ec 1c             	sub    $0x1c,%esp
  8003f5:	89 c7                	mov    %eax,%edi
  8003f7:	89 d6                	mov    %edx,%esi
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800402:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800405:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800408:	bb 00 00 00 00       	mov    $0x0,%ebx
  80040d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800410:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800413:	39 d3                	cmp    %edx,%ebx
  800415:	72 05                	jb     80041c <printnum+0x30>
  800417:	39 45 10             	cmp    %eax,0x10(%ebp)
  80041a:	77 7a                	ja     800496 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80041c:	83 ec 0c             	sub    $0xc,%esp
  80041f:	ff 75 18             	pushl  0x18(%ebp)
  800422:	8b 45 14             	mov    0x14(%ebp),%eax
  800425:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800428:	53                   	push   %ebx
  800429:	ff 75 10             	pushl  0x10(%ebp)
  80042c:	83 ec 08             	sub    $0x8,%esp
  80042f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800432:	ff 75 e0             	pushl  -0x20(%ebp)
  800435:	ff 75 dc             	pushl  -0x24(%ebp)
  800438:	ff 75 d8             	pushl  -0x28(%ebp)
  80043b:	e8 40 09 00 00       	call   800d80 <__udivdi3>
  800440:	83 c4 18             	add    $0x18,%esp
  800443:	52                   	push   %edx
  800444:	50                   	push   %eax
  800445:	89 f2                	mov    %esi,%edx
  800447:	89 f8                	mov    %edi,%eax
  800449:	e8 9e ff ff ff       	call   8003ec <printnum>
  80044e:	83 c4 20             	add    $0x20,%esp
  800451:	eb 13                	jmp    800466 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	56                   	push   %esi
  800457:	ff 75 18             	pushl  0x18(%ebp)
  80045a:	ff d7                	call   *%edi
  80045c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80045f:	83 eb 01             	sub    $0x1,%ebx
  800462:	85 db                	test   %ebx,%ebx
  800464:	7f ed                	jg     800453 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800466:	83 ec 08             	sub    $0x8,%esp
  800469:	56                   	push   %esi
  80046a:	83 ec 04             	sub    $0x4,%esp
  80046d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800470:	ff 75 e0             	pushl  -0x20(%ebp)
  800473:	ff 75 dc             	pushl  -0x24(%ebp)
  800476:	ff 75 d8             	pushl  -0x28(%ebp)
  800479:	e8 22 0a 00 00       	call   800ea0 <__umoddi3>
  80047e:	83 c4 14             	add    $0x14,%esp
  800481:	0f be 80 1e 10 80 00 	movsbl 0x80101e(%eax),%eax
  800488:	50                   	push   %eax
  800489:	ff d7                	call   *%edi
}
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800491:	5b                   	pop    %ebx
  800492:	5e                   	pop    %esi
  800493:	5f                   	pop    %edi
  800494:	5d                   	pop    %ebp
  800495:	c3                   	ret    
  800496:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800499:	eb c4                	jmp    80045f <printnum+0x73>

0080049b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80049b:	55                   	push   %ebp
  80049c:	89 e5                	mov    %esp,%ebp
  80049e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004a1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004a5:	8b 10                	mov    (%eax),%edx
  8004a7:	3b 50 04             	cmp    0x4(%eax),%edx
  8004aa:	73 0a                	jae    8004b6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004af:	89 08                	mov    %ecx,(%eax)
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	88 02                	mov    %al,(%edx)
}
  8004b6:	5d                   	pop    %ebp
  8004b7:	c3                   	ret    

008004b8 <printfmt>:
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004be:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004c1:	50                   	push   %eax
  8004c2:	ff 75 10             	pushl  0x10(%ebp)
  8004c5:	ff 75 0c             	pushl  0xc(%ebp)
  8004c8:	ff 75 08             	pushl  0x8(%ebp)
  8004cb:	e8 05 00 00 00       	call   8004d5 <vprintfmt>
}
  8004d0:	83 c4 10             	add    $0x10,%esp
  8004d3:	c9                   	leave  
  8004d4:	c3                   	ret    

008004d5 <vprintfmt>:
{
  8004d5:	55                   	push   %ebp
  8004d6:	89 e5                	mov    %esp,%ebp
  8004d8:	57                   	push   %edi
  8004d9:	56                   	push   %esi
  8004da:	53                   	push   %ebx
  8004db:	83 ec 2c             	sub    $0x2c,%esp
  8004de:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004e4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004e7:	e9 00 04 00 00       	jmp    8008ec <vprintfmt+0x417>
		padc = ' ';
  8004ec:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8004f0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8004f7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8004fe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800505:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	8d 47 01             	lea    0x1(%edi),%eax
  80050d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800510:	0f b6 17             	movzbl (%edi),%edx
  800513:	8d 42 dd             	lea    -0x23(%edx),%eax
  800516:	3c 55                	cmp    $0x55,%al
  800518:	0f 87 51 04 00 00    	ja     80096f <vprintfmt+0x49a>
  80051e:	0f b6 c0             	movzbl %al,%eax
  800521:	ff 24 85 e0 10 80 00 	jmp    *0x8010e0(,%eax,4)
  800528:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80052b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80052f:	eb d9                	jmp    80050a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800531:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800534:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800538:	eb d0                	jmp    80050a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80053a:	0f b6 d2             	movzbl %dl,%edx
  80053d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800540:	b8 00 00 00 00       	mov    $0x0,%eax
  800545:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800548:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80054b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80054f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800552:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800555:	83 f9 09             	cmp    $0x9,%ecx
  800558:	77 55                	ja     8005af <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80055a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80055d:	eb e9                	jmp    800548 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 04             	lea    0x4(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800570:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800573:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800577:	79 91                	jns    80050a <vprintfmt+0x35>
				width = precision, precision = -1;
  800579:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80057c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80057f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800586:	eb 82                	jmp    80050a <vprintfmt+0x35>
  800588:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80058b:	85 c0                	test   %eax,%eax
  80058d:	ba 00 00 00 00       	mov    $0x0,%edx
  800592:	0f 49 d0             	cmovns %eax,%edx
  800595:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800598:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80059b:	e9 6a ff ff ff       	jmp    80050a <vprintfmt+0x35>
  8005a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005a3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005aa:	e9 5b ff ff ff       	jmp    80050a <vprintfmt+0x35>
  8005af:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b5:	eb bc                	jmp    800573 <vprintfmt+0x9e>
			lflag++;
  8005b7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005bd:	e9 48 ff ff ff       	jmp    80050a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8d 78 04             	lea    0x4(%eax),%edi
  8005c8:	83 ec 08             	sub    $0x8,%esp
  8005cb:	53                   	push   %ebx
  8005cc:	ff 30                	pushl  (%eax)
  8005ce:	ff d6                	call   *%esi
			break;
  8005d0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005d3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005d6:	e9 0e 03 00 00       	jmp    8008e9 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8d 78 04             	lea    0x4(%eax),%edi
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	99                   	cltd   
  8005e4:	31 d0                	xor    %edx,%eax
  8005e6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005e8:	83 f8 08             	cmp    $0x8,%eax
  8005eb:	7f 23                	jg     800610 <vprintfmt+0x13b>
  8005ed:	8b 14 85 40 12 80 00 	mov    0x801240(,%eax,4),%edx
  8005f4:	85 d2                	test   %edx,%edx
  8005f6:	74 18                	je     800610 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8005f8:	52                   	push   %edx
  8005f9:	68 3f 10 80 00       	push   $0x80103f
  8005fe:	53                   	push   %ebx
  8005ff:	56                   	push   %esi
  800600:	e8 b3 fe ff ff       	call   8004b8 <printfmt>
  800605:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800608:	89 7d 14             	mov    %edi,0x14(%ebp)
  80060b:	e9 d9 02 00 00       	jmp    8008e9 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800610:	50                   	push   %eax
  800611:	68 36 10 80 00       	push   $0x801036
  800616:	53                   	push   %ebx
  800617:	56                   	push   %esi
  800618:	e8 9b fe ff ff       	call   8004b8 <printfmt>
  80061d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800620:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800623:	e9 c1 02 00 00       	jmp    8008e9 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	83 c0 04             	add    $0x4,%eax
  80062e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800636:	85 ff                	test   %edi,%edi
  800638:	b8 2f 10 80 00       	mov    $0x80102f,%eax
  80063d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800640:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800644:	0f 8e bd 00 00 00    	jle    800707 <vprintfmt+0x232>
  80064a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80064e:	75 0e                	jne    80065e <vprintfmt+0x189>
  800650:	89 75 08             	mov    %esi,0x8(%ebp)
  800653:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800656:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800659:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80065c:	eb 6d                	jmp    8006cb <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 d0             	pushl  -0x30(%ebp)
  800664:	57                   	push   %edi
  800665:	e8 ad 03 00 00       	call   800a17 <strnlen>
  80066a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80066d:	29 c1                	sub    %eax,%ecx
  80066f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800672:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800675:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800679:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80067c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80067f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	eb 0f                	jmp    800692 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	53                   	push   %ebx
  800687:	ff 75 e0             	pushl  -0x20(%ebp)
  80068a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80068c:	83 ef 01             	sub    $0x1,%edi
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	85 ff                	test   %edi,%edi
  800694:	7f ed                	jg     800683 <vprintfmt+0x1ae>
  800696:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800699:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80069c:	85 c9                	test   %ecx,%ecx
  80069e:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a3:	0f 49 c1             	cmovns %ecx,%eax
  8006a6:	29 c1                	sub    %eax,%ecx
  8006a8:	89 75 08             	mov    %esi,0x8(%ebp)
  8006ab:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006ae:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006b1:	89 cb                	mov    %ecx,%ebx
  8006b3:	eb 16                	jmp    8006cb <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006b9:	75 31                	jne    8006ec <vprintfmt+0x217>
					putch(ch, putdat);
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	ff 75 0c             	pushl  0xc(%ebp)
  8006c1:	50                   	push   %eax
  8006c2:	ff 55 08             	call   *0x8(%ebp)
  8006c5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c8:	83 eb 01             	sub    $0x1,%ebx
  8006cb:	83 c7 01             	add    $0x1,%edi
  8006ce:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006d2:	0f be c2             	movsbl %dl,%eax
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	74 59                	je     800732 <vprintfmt+0x25d>
  8006d9:	85 f6                	test   %esi,%esi
  8006db:	78 d8                	js     8006b5 <vprintfmt+0x1e0>
  8006dd:	83 ee 01             	sub    $0x1,%esi
  8006e0:	79 d3                	jns    8006b5 <vprintfmt+0x1e0>
  8006e2:	89 df                	mov    %ebx,%edi
  8006e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8006e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006ea:	eb 37                	jmp    800723 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ec:	0f be d2             	movsbl %dl,%edx
  8006ef:	83 ea 20             	sub    $0x20,%edx
  8006f2:	83 fa 5e             	cmp    $0x5e,%edx
  8006f5:	76 c4                	jbe    8006bb <vprintfmt+0x1e6>
					putch('?', putdat);
  8006f7:	83 ec 08             	sub    $0x8,%esp
  8006fa:	ff 75 0c             	pushl  0xc(%ebp)
  8006fd:	6a 3f                	push   $0x3f
  8006ff:	ff 55 08             	call   *0x8(%ebp)
  800702:	83 c4 10             	add    $0x10,%esp
  800705:	eb c1                	jmp    8006c8 <vprintfmt+0x1f3>
  800707:	89 75 08             	mov    %esi,0x8(%ebp)
  80070a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80070d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800710:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800713:	eb b6                	jmp    8006cb <vprintfmt+0x1f6>
				putch(' ', putdat);
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	53                   	push   %ebx
  800719:	6a 20                	push   $0x20
  80071b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80071d:	83 ef 01             	sub    $0x1,%edi
  800720:	83 c4 10             	add    $0x10,%esp
  800723:	85 ff                	test   %edi,%edi
  800725:	7f ee                	jg     800715 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800727:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
  80072d:	e9 b7 01 00 00       	jmp    8008e9 <vprintfmt+0x414>
  800732:	89 df                	mov    %ebx,%edi
  800734:	8b 75 08             	mov    0x8(%ebp),%esi
  800737:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80073a:	eb e7                	jmp    800723 <vprintfmt+0x24e>
	if (lflag >= 2)
  80073c:	83 f9 01             	cmp    $0x1,%ecx
  80073f:	7e 3f                	jle    800780 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 50 04             	mov    0x4(%eax),%edx
  800747:	8b 00                	mov    (%eax),%eax
  800749:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 40 08             	lea    0x8(%eax),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800758:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80075c:	79 5c                	jns    8007ba <vprintfmt+0x2e5>
				putch('-', putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	53                   	push   %ebx
  800762:	6a 2d                	push   $0x2d
  800764:	ff d6                	call   *%esi
				num = -(long long) num;
  800766:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800769:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80076c:	f7 da                	neg    %edx
  80076e:	83 d1 00             	adc    $0x0,%ecx
  800771:	f7 d9                	neg    %ecx
  800773:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800776:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077b:	e9 4f 01 00 00       	jmp    8008cf <vprintfmt+0x3fa>
	else if (lflag)
  800780:	85 c9                	test   %ecx,%ecx
  800782:	75 1b                	jne    80079f <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078c:	89 c1                	mov    %eax,%ecx
  80078e:	c1 f9 1f             	sar    $0x1f,%ecx
  800791:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 40 04             	lea    0x4(%eax),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
  80079d:	eb b9                	jmp    800758 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a7:	89 c1                	mov    %eax,%ecx
  8007a9:	c1 f9 1f             	sar    $0x1f,%ecx
  8007ac:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8d 40 04             	lea    0x4(%eax),%eax
  8007b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b8:	eb 9e                	jmp    800758 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007ba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007bd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c5:	e9 05 01 00 00       	jmp    8008cf <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007ca:	83 f9 01             	cmp    $0x1,%ecx
  8007cd:	7e 18                	jle    8007e7 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8b 10                	mov    (%eax),%edx
  8007d4:	8b 48 04             	mov    0x4(%eax),%ecx
  8007d7:	8d 40 08             	lea    0x8(%eax),%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e2:	e9 e8 00 00 00       	jmp    8008cf <vprintfmt+0x3fa>
	else if (lflag)
  8007e7:	85 c9                	test   %ecx,%ecx
  8007e9:	75 1a                	jne    800805 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 10                	mov    (%eax),%edx
  8007f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f5:	8d 40 04             	lea    0x4(%eax),%eax
  8007f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800800:	e9 ca 00 00 00       	jmp    8008cf <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8b 10                	mov    (%eax),%edx
  80080a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80080f:	8d 40 04             	lea    0x4(%eax),%eax
  800812:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800815:	b8 0a 00 00 00       	mov    $0xa,%eax
  80081a:	e9 b0 00 00 00       	jmp    8008cf <vprintfmt+0x3fa>
	if (lflag >= 2)
  80081f:	83 f9 01             	cmp    $0x1,%ecx
  800822:	7e 3c                	jle    800860 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 50 04             	mov    0x4(%eax),%edx
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8d 40 08             	lea    0x8(%eax),%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80083b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80083f:	79 59                	jns    80089a <vprintfmt+0x3c5>
                putch('-', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	53                   	push   %ebx
  800845:	6a 2d                	push   $0x2d
  800847:	ff d6                	call   *%esi
                num = -(long long) num;
  800849:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80084c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80084f:	f7 da                	neg    %edx
  800851:	83 d1 00             	adc    $0x0,%ecx
  800854:	f7 d9                	neg    %ecx
  800856:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800859:	b8 08 00 00 00       	mov    $0x8,%eax
  80085e:	eb 6f                	jmp    8008cf <vprintfmt+0x3fa>
	else if (lflag)
  800860:	85 c9                	test   %ecx,%ecx
  800862:	75 1b                	jne    80087f <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086c:	89 c1                	mov    %eax,%ecx
  80086e:	c1 f9 1f             	sar    $0x1f,%ecx
  800871:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8d 40 04             	lea    0x4(%eax),%eax
  80087a:	89 45 14             	mov    %eax,0x14(%ebp)
  80087d:	eb bc                	jmp    80083b <vprintfmt+0x366>
		return va_arg(*ap, long);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8b 00                	mov    (%eax),%eax
  800884:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800887:	89 c1                	mov    %eax,%ecx
  800889:	c1 f9 1f             	sar    $0x1f,%ecx
  80088c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8d 40 04             	lea    0x4(%eax),%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
  800898:	eb a1                	jmp    80083b <vprintfmt+0x366>
            num = getint(&ap, lflag);
  80089a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80089d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8008a0:	b8 08 00 00 00       	mov    $0x8,%eax
  8008a5:	eb 28                	jmp    8008cf <vprintfmt+0x3fa>
			putch('0', putdat);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	53                   	push   %ebx
  8008ab:	6a 30                	push   $0x30
  8008ad:	ff d6                	call   *%esi
			putch('x', putdat);
  8008af:	83 c4 08             	add    $0x8,%esp
  8008b2:	53                   	push   %ebx
  8008b3:	6a 78                	push   $0x78
  8008b5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ba:	8b 10                	mov    (%eax),%edx
  8008bc:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008c1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008c4:	8d 40 04             	lea    0x4(%eax),%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ca:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008cf:	83 ec 0c             	sub    $0xc,%esp
  8008d2:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008d6:	57                   	push   %edi
  8008d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8008da:	50                   	push   %eax
  8008db:	51                   	push   %ecx
  8008dc:	52                   	push   %edx
  8008dd:	89 da                	mov    %ebx,%edx
  8008df:	89 f0                	mov    %esi,%eax
  8008e1:	e8 06 fb ff ff       	call   8003ec <printnum>
			break;
  8008e6:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ec:	83 c7 01             	add    $0x1,%edi
  8008ef:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008f3:	83 f8 25             	cmp    $0x25,%eax
  8008f6:	0f 84 f0 fb ff ff    	je     8004ec <vprintfmt+0x17>
			if (ch == '\0')
  8008fc:	85 c0                	test   %eax,%eax
  8008fe:	0f 84 8b 00 00 00    	je     80098f <vprintfmt+0x4ba>
			putch(ch, putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	53                   	push   %ebx
  800908:	50                   	push   %eax
  800909:	ff d6                	call   *%esi
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	eb dc                	jmp    8008ec <vprintfmt+0x417>
	if (lflag >= 2)
  800910:	83 f9 01             	cmp    $0x1,%ecx
  800913:	7e 15                	jle    80092a <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	8b 10                	mov    (%eax),%edx
  80091a:	8b 48 04             	mov    0x4(%eax),%ecx
  80091d:	8d 40 08             	lea    0x8(%eax),%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800923:	b8 10 00 00 00       	mov    $0x10,%eax
  800928:	eb a5                	jmp    8008cf <vprintfmt+0x3fa>
	else if (lflag)
  80092a:	85 c9                	test   %ecx,%ecx
  80092c:	75 17                	jne    800945 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  80092e:	8b 45 14             	mov    0x14(%ebp),%eax
  800931:	8b 10                	mov    (%eax),%edx
  800933:	b9 00 00 00 00       	mov    $0x0,%ecx
  800938:	8d 40 04             	lea    0x4(%eax),%eax
  80093b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093e:	b8 10 00 00 00       	mov    $0x10,%eax
  800943:	eb 8a                	jmp    8008cf <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800945:	8b 45 14             	mov    0x14(%ebp),%eax
  800948:	8b 10                	mov    (%eax),%edx
  80094a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80094f:	8d 40 04             	lea    0x4(%eax),%eax
  800952:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800955:	b8 10 00 00 00       	mov    $0x10,%eax
  80095a:	e9 70 ff ff ff       	jmp    8008cf <vprintfmt+0x3fa>
			putch(ch, putdat);
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	53                   	push   %ebx
  800963:	6a 25                	push   $0x25
  800965:	ff d6                	call   *%esi
			break;
  800967:	83 c4 10             	add    $0x10,%esp
  80096a:	e9 7a ff ff ff       	jmp    8008e9 <vprintfmt+0x414>
			putch('%', putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	53                   	push   %ebx
  800973:	6a 25                	push   $0x25
  800975:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800977:	83 c4 10             	add    $0x10,%esp
  80097a:	89 f8                	mov    %edi,%eax
  80097c:	eb 03                	jmp    800981 <vprintfmt+0x4ac>
  80097e:	83 e8 01             	sub    $0x1,%eax
  800981:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800985:	75 f7                	jne    80097e <vprintfmt+0x4a9>
  800987:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80098a:	e9 5a ff ff ff       	jmp    8008e9 <vprintfmt+0x414>
}
  80098f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800992:	5b                   	pop    %ebx
  800993:	5e                   	pop    %esi
  800994:	5f                   	pop    %edi
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	83 ec 18             	sub    $0x18,%esp
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009a6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009b4:	85 c0                	test   %eax,%eax
  8009b6:	74 26                	je     8009de <vsnprintf+0x47>
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	7e 22                	jle    8009de <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009bc:	ff 75 14             	pushl  0x14(%ebp)
  8009bf:	ff 75 10             	pushl  0x10(%ebp)
  8009c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009c5:	50                   	push   %eax
  8009c6:	68 9b 04 80 00       	push   $0x80049b
  8009cb:	e8 05 fb ff ff       	call   8004d5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d9:	83 c4 10             	add    $0x10,%esp
}
  8009dc:	c9                   	leave  
  8009dd:	c3                   	ret    
		return -E_INVAL;
  8009de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e3:	eb f7                	jmp    8009dc <vsnprintf+0x45>

008009e5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009eb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009ee:	50                   	push   %eax
  8009ef:	ff 75 10             	pushl  0x10(%ebp)
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	ff 75 08             	pushl  0x8(%ebp)
  8009f8:	e8 9a ff ff ff       	call   800997 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a05:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0a:	eb 03                	jmp    800a0f <strlen+0x10>
		n++;
  800a0c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a0f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a13:	75 f7                	jne    800a0c <strlen+0xd>
	return n;
}
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a20:	b8 00 00 00 00       	mov    $0x0,%eax
  800a25:	eb 03                	jmp    800a2a <strnlen+0x13>
		n++;
  800a27:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a2a:	39 d0                	cmp    %edx,%eax
  800a2c:	74 06                	je     800a34 <strnlen+0x1d>
  800a2e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a32:	75 f3                	jne    800a27 <strnlen+0x10>
	return n;
}
  800a34:	5d                   	pop    %ebp
  800a35:	c3                   	ret    

00800a36 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	53                   	push   %ebx
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a40:	89 c2                	mov    %eax,%edx
  800a42:	83 c1 01             	add    $0x1,%ecx
  800a45:	83 c2 01             	add    $0x1,%edx
  800a48:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a4c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a4f:	84 db                	test   %bl,%bl
  800a51:	75 ef                	jne    800a42 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a53:	5b                   	pop    %ebx
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	53                   	push   %ebx
  800a5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a5d:	53                   	push   %ebx
  800a5e:	e8 9c ff ff ff       	call   8009ff <strlen>
  800a63:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	01 d8                	add    %ebx,%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 c5 ff ff ff       	call   800a36 <strcpy>
	return dst;
}
  800a71:	89 d8                	mov    %ebx,%eax
  800a73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a76:	c9                   	leave  
  800a77:	c3                   	ret    

00800a78 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	56                   	push   %esi
  800a7c:	53                   	push   %ebx
  800a7d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a83:	89 f3                	mov    %esi,%ebx
  800a85:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a88:	89 f2                	mov    %esi,%edx
  800a8a:	eb 0f                	jmp    800a9b <strncpy+0x23>
		*dst++ = *src;
  800a8c:	83 c2 01             	add    $0x1,%edx
  800a8f:	0f b6 01             	movzbl (%ecx),%eax
  800a92:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a95:	80 39 01             	cmpb   $0x1,(%ecx)
  800a98:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a9b:	39 da                	cmp    %ebx,%edx
  800a9d:	75 ed                	jne    800a8c <strncpy+0x14>
	}
	return ret;
}
  800a9f:	89 f0                	mov    %esi,%eax
  800aa1:	5b                   	pop    %ebx
  800aa2:	5e                   	pop    %esi
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	56                   	push   %esi
  800aa9:	53                   	push   %ebx
  800aaa:	8b 75 08             	mov    0x8(%ebp),%esi
  800aad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ab3:	89 f0                	mov    %esi,%eax
  800ab5:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ab9:	85 c9                	test   %ecx,%ecx
  800abb:	75 0b                	jne    800ac8 <strlcpy+0x23>
  800abd:	eb 17                	jmp    800ad6 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800abf:	83 c2 01             	add    $0x1,%edx
  800ac2:	83 c0 01             	add    $0x1,%eax
  800ac5:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ac8:	39 d8                	cmp    %ebx,%eax
  800aca:	74 07                	je     800ad3 <strlcpy+0x2e>
  800acc:	0f b6 0a             	movzbl (%edx),%ecx
  800acf:	84 c9                	test   %cl,%cl
  800ad1:	75 ec                	jne    800abf <strlcpy+0x1a>
		*dst = '\0';
  800ad3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad6:	29 f0                	sub    %esi,%eax
}
  800ad8:	5b                   	pop    %ebx
  800ad9:	5e                   	pop    %esi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ae5:	eb 06                	jmp    800aed <strcmp+0x11>
		p++, q++;
  800ae7:	83 c1 01             	add    $0x1,%ecx
  800aea:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800aed:	0f b6 01             	movzbl (%ecx),%eax
  800af0:	84 c0                	test   %al,%al
  800af2:	74 04                	je     800af8 <strcmp+0x1c>
  800af4:	3a 02                	cmp    (%edx),%al
  800af6:	74 ef                	je     800ae7 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af8:	0f b6 c0             	movzbl %al,%eax
  800afb:	0f b6 12             	movzbl (%edx),%edx
  800afe:	29 d0                	sub    %edx,%eax
}
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	53                   	push   %ebx
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0c:	89 c3                	mov    %eax,%ebx
  800b0e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b11:	eb 06                	jmp    800b19 <strncmp+0x17>
		n--, p++, q++;
  800b13:	83 c0 01             	add    $0x1,%eax
  800b16:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b19:	39 d8                	cmp    %ebx,%eax
  800b1b:	74 16                	je     800b33 <strncmp+0x31>
  800b1d:	0f b6 08             	movzbl (%eax),%ecx
  800b20:	84 c9                	test   %cl,%cl
  800b22:	74 04                	je     800b28 <strncmp+0x26>
  800b24:	3a 0a                	cmp    (%edx),%cl
  800b26:	74 eb                	je     800b13 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b28:	0f b6 00             	movzbl (%eax),%eax
  800b2b:	0f b6 12             	movzbl (%edx),%edx
  800b2e:	29 d0                	sub    %edx,%eax
}
  800b30:	5b                   	pop    %ebx
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    
		return 0;
  800b33:	b8 00 00 00 00       	mov    $0x0,%eax
  800b38:	eb f6                	jmp    800b30 <strncmp+0x2e>

00800b3a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b44:	0f b6 10             	movzbl (%eax),%edx
  800b47:	84 d2                	test   %dl,%dl
  800b49:	74 09                	je     800b54 <strchr+0x1a>
		if (*s == c)
  800b4b:	38 ca                	cmp    %cl,%dl
  800b4d:	74 0a                	je     800b59 <strchr+0x1f>
	for (; *s; s++)
  800b4f:	83 c0 01             	add    $0x1,%eax
  800b52:	eb f0                	jmp    800b44 <strchr+0xa>
			return (char *) s;
	return 0;
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b65:	eb 03                	jmp    800b6a <strfind+0xf>
  800b67:	83 c0 01             	add    $0x1,%eax
  800b6a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b6d:	38 ca                	cmp    %cl,%dl
  800b6f:	74 04                	je     800b75 <strfind+0x1a>
  800b71:	84 d2                	test   %dl,%dl
  800b73:	75 f2                	jne    800b67 <strfind+0xc>
			break;
	return (char *) s;
}
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	57                   	push   %edi
  800b7b:	56                   	push   %esi
  800b7c:	53                   	push   %ebx
  800b7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b80:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b83:	85 c9                	test   %ecx,%ecx
  800b85:	74 13                	je     800b9a <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b87:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b8d:	75 05                	jne    800b94 <memset+0x1d>
  800b8f:	f6 c1 03             	test   $0x3,%cl
  800b92:	74 0d                	je     800ba1 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	fc                   	cld    
  800b98:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b9a:	89 f8                	mov    %edi,%eax
  800b9c:	5b                   	pop    %ebx
  800b9d:	5e                   	pop    %esi
  800b9e:	5f                   	pop    %edi
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    
		c &= 0xFF;
  800ba1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ba5:	89 d3                	mov    %edx,%ebx
  800ba7:	c1 e3 08             	shl    $0x8,%ebx
  800baa:	89 d0                	mov    %edx,%eax
  800bac:	c1 e0 18             	shl    $0x18,%eax
  800baf:	89 d6                	mov    %edx,%esi
  800bb1:	c1 e6 10             	shl    $0x10,%esi
  800bb4:	09 f0                	or     %esi,%eax
  800bb6:	09 c2                	or     %eax,%edx
  800bb8:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bba:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bbd:	89 d0                	mov    %edx,%eax
  800bbf:	fc                   	cld    
  800bc0:	f3 ab                	rep stos %eax,%es:(%edi)
  800bc2:	eb d6                	jmp    800b9a <memset+0x23>

00800bc4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	57                   	push   %edi
  800bc8:	56                   	push   %esi
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bcf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bd2:	39 c6                	cmp    %eax,%esi
  800bd4:	73 35                	jae    800c0b <memmove+0x47>
  800bd6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bd9:	39 c2                	cmp    %eax,%edx
  800bdb:	76 2e                	jbe    800c0b <memmove+0x47>
		s += n;
		d += n;
  800bdd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be0:	89 d6                	mov    %edx,%esi
  800be2:	09 fe                	or     %edi,%esi
  800be4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bea:	74 0c                	je     800bf8 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bec:	83 ef 01             	sub    $0x1,%edi
  800bef:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bf2:	fd                   	std    
  800bf3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bf5:	fc                   	cld    
  800bf6:	eb 21                	jmp    800c19 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf8:	f6 c1 03             	test   $0x3,%cl
  800bfb:	75 ef                	jne    800bec <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bfd:	83 ef 04             	sub    $0x4,%edi
  800c00:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c03:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c06:	fd                   	std    
  800c07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c09:	eb ea                	jmp    800bf5 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0b:	89 f2                	mov    %esi,%edx
  800c0d:	09 c2                	or     %eax,%edx
  800c0f:	f6 c2 03             	test   $0x3,%dl
  800c12:	74 09                	je     800c1d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c14:	89 c7                	mov    %eax,%edi
  800c16:	fc                   	cld    
  800c17:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c1d:	f6 c1 03             	test   $0x3,%cl
  800c20:	75 f2                	jne    800c14 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c22:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c25:	89 c7                	mov    %eax,%edi
  800c27:	fc                   	cld    
  800c28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2a:	eb ed                	jmp    800c19 <memmove+0x55>

00800c2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c2f:	ff 75 10             	pushl  0x10(%ebp)
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	ff 75 08             	pushl  0x8(%ebp)
  800c38:	e8 87 ff ff ff       	call   800bc4 <memmove>
}
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    

00800c3f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	56                   	push   %esi
  800c43:	53                   	push   %ebx
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4a:	89 c6                	mov    %eax,%esi
  800c4c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c4f:	39 f0                	cmp    %esi,%eax
  800c51:	74 1c                	je     800c6f <memcmp+0x30>
		if (*s1 != *s2)
  800c53:	0f b6 08             	movzbl (%eax),%ecx
  800c56:	0f b6 1a             	movzbl (%edx),%ebx
  800c59:	38 d9                	cmp    %bl,%cl
  800c5b:	75 08                	jne    800c65 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c5d:	83 c0 01             	add    $0x1,%eax
  800c60:	83 c2 01             	add    $0x1,%edx
  800c63:	eb ea                	jmp    800c4f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c65:	0f b6 c1             	movzbl %cl,%eax
  800c68:	0f b6 db             	movzbl %bl,%ebx
  800c6b:	29 d8                	sub    %ebx,%eax
  800c6d:	eb 05                	jmp    800c74 <memcmp+0x35>
	}

	return 0;
  800c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c74:	5b                   	pop    %ebx
  800c75:	5e                   	pop    %esi
  800c76:	5d                   	pop    %ebp
  800c77:	c3                   	ret    

00800c78 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c81:	89 c2                	mov    %eax,%edx
  800c83:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c86:	39 d0                	cmp    %edx,%eax
  800c88:	73 09                	jae    800c93 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c8a:	38 08                	cmp    %cl,(%eax)
  800c8c:	74 05                	je     800c93 <memfind+0x1b>
	for (; s < ends; s++)
  800c8e:	83 c0 01             	add    $0x1,%eax
  800c91:	eb f3                	jmp    800c86 <memfind+0xe>
			break;
	return (void *) s;
}
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
  800c9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca1:	eb 03                	jmp    800ca6 <strtol+0x11>
		s++;
  800ca3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ca6:	0f b6 01             	movzbl (%ecx),%eax
  800ca9:	3c 20                	cmp    $0x20,%al
  800cab:	74 f6                	je     800ca3 <strtol+0xe>
  800cad:	3c 09                	cmp    $0x9,%al
  800caf:	74 f2                	je     800ca3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cb1:	3c 2b                	cmp    $0x2b,%al
  800cb3:	74 2e                	je     800ce3 <strtol+0x4e>
	int neg = 0;
  800cb5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cba:	3c 2d                	cmp    $0x2d,%al
  800cbc:	74 2f                	je     800ced <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cbe:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cc4:	75 05                	jne    800ccb <strtol+0x36>
  800cc6:	80 39 30             	cmpb   $0x30,(%ecx)
  800cc9:	74 2c                	je     800cf7 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ccb:	85 db                	test   %ebx,%ebx
  800ccd:	75 0a                	jne    800cd9 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ccf:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cd4:	80 39 30             	cmpb   $0x30,(%ecx)
  800cd7:	74 28                	je     800d01 <strtol+0x6c>
		base = 10;
  800cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cde:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ce1:	eb 50                	jmp    800d33 <strtol+0x9e>
		s++;
  800ce3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ce6:	bf 00 00 00 00       	mov    $0x0,%edi
  800ceb:	eb d1                	jmp    800cbe <strtol+0x29>
		s++, neg = 1;
  800ced:	83 c1 01             	add    $0x1,%ecx
  800cf0:	bf 01 00 00 00       	mov    $0x1,%edi
  800cf5:	eb c7                	jmp    800cbe <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cfb:	74 0e                	je     800d0b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800cfd:	85 db                	test   %ebx,%ebx
  800cff:	75 d8                	jne    800cd9 <strtol+0x44>
		s++, base = 8;
  800d01:	83 c1 01             	add    $0x1,%ecx
  800d04:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d09:	eb ce                	jmp    800cd9 <strtol+0x44>
		s += 2, base = 16;
  800d0b:	83 c1 02             	add    $0x2,%ecx
  800d0e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d13:	eb c4                	jmp    800cd9 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d15:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d18:	89 f3                	mov    %esi,%ebx
  800d1a:	80 fb 19             	cmp    $0x19,%bl
  800d1d:	77 29                	ja     800d48 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d1f:	0f be d2             	movsbl %dl,%edx
  800d22:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d25:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d28:	7d 30                	jge    800d5a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d2a:	83 c1 01             	add    $0x1,%ecx
  800d2d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d31:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d33:	0f b6 11             	movzbl (%ecx),%edx
  800d36:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d39:	89 f3                	mov    %esi,%ebx
  800d3b:	80 fb 09             	cmp    $0x9,%bl
  800d3e:	77 d5                	ja     800d15 <strtol+0x80>
			dig = *s - '0';
  800d40:	0f be d2             	movsbl %dl,%edx
  800d43:	83 ea 30             	sub    $0x30,%edx
  800d46:	eb dd                	jmp    800d25 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d48:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d4b:	89 f3                	mov    %esi,%ebx
  800d4d:	80 fb 19             	cmp    $0x19,%bl
  800d50:	77 08                	ja     800d5a <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d52:	0f be d2             	movsbl %dl,%edx
  800d55:	83 ea 37             	sub    $0x37,%edx
  800d58:	eb cb                	jmp    800d25 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d5e:	74 05                	je     800d65 <strtol+0xd0>
		*endptr = (char *) s;
  800d60:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d63:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d65:	89 c2                	mov    %eax,%edx
  800d67:	f7 da                	neg    %edx
  800d69:	85 ff                	test   %edi,%edi
  800d6b:	0f 45 c2             	cmovne %edx,%eax
}
  800d6e:	5b                   	pop    %ebx
  800d6f:	5e                   	pop    %esi
  800d70:	5f                   	pop    %edi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    
  800d73:	66 90                	xchg   %ax,%ax
  800d75:	66 90                	xchg   %ax,%ax
  800d77:	66 90                	xchg   %ax,%ax
  800d79:	66 90                	xchg   %ax,%ax
  800d7b:	66 90                	xchg   %ax,%ax
  800d7d:	66 90                	xchg   %ax,%ax
  800d7f:	90                   	nop

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
