
obj/user/faultnostack：     文件格式 elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 17 03 80 00       	push   $0x800317
  80003e:	6a 00                	push   $0x0
  800040:	e8 2c 02 00 00       	call   800271 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	56                   	push   %esi
  800058:	53                   	push   %ebx
  800059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005f:	e8 c6 00 00 00       	call   80012a <sys_getenvid>
  800064:	25 ff 03 00 00       	and    $0x3ff,%eax
  800069:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800071:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800076:	85 db                	test   %ebx,%ebx
  800078:	7e 07                	jle    800081 <libmain+0x2d>
		binaryname = argv[0];
  80007a:	8b 06                	mov    (%esi),%eax
  80007c:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800081:	83 ec 08             	sub    $0x8,%esp
  800084:	56                   	push   %esi
  800085:	53                   	push   %ebx
  800086:	e8 a8 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008b:	e8 0a 00 00 00       	call   80009a <exit>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    

0080009a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 42 00 00 00       	call   8000e9 <sys_env_destroy>
}
  8000a7:	83 c4 10             	add    $0x10,%esp
  8000aa:	c9                   	leave  
  8000ab:	c3                   	ret    

008000ac <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	57                   	push   %edi
  8000b0:	56                   	push   %esi
  8000b1:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bd:	89 c3                	mov    %eax,%ebx
  8000bf:	89 c7                	mov    %eax,%edi
  8000c1:	89 c6                	mov    %eax,%esi
  8000c3:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000c5:	5b                   	pop    %ebx
  8000c6:	5e                   	pop    %esi
  8000c7:	5f                   	pop    %edi
  8000c8:	5d                   	pop    %ebp
  8000c9:	c3                   	ret    

008000ca <sys_cgetc>:

int
sys_cgetc(void) {
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	57                   	push   %edi
  8000ce:	56                   	push   %esi
  8000cf:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8000da:	89 d1                	mov    %edx,%ecx
  8000dc:	89 d3                	mov    %edx,%ebx
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	89 d6                	mov    %edx,%esi
  8000e2:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5f                   	pop    %edi
  8000e7:	5d                   	pop    %ebp
  8000e8:	c3                   	ret    

008000e9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fa:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ff:	89 cb                	mov    %ecx,%ebx
  800101:	89 cf                	mov    %ecx,%edi
  800103:	89 ce                	mov    %ecx,%esi
  800105:	cd 30                	int    $0x30
    if (check && ret > 0)
  800107:	85 c0                	test   %eax,%eax
  800109:	7f 08                	jg     800113 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010e:	5b                   	pop    %ebx
  80010f:	5e                   	pop    %esi
  800110:	5f                   	pop    %edi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	50                   	push   %eax
  800117:	6a 03                	push   $0x3
  800119:	68 6a 10 80 00       	push   $0x80106a
  80011e:	6a 24                	push   $0x24
  800120:	68 87 10 80 00       	push   $0x801087
  800125:	e8 13 02 00 00       	call   80033d <_panic>

0080012a <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	57                   	push   %edi
  80012e:	56                   	push   %esi
  80012f:	53                   	push   %ebx
    asm volatile("int %1\n"
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	b8 02 00 00 00       	mov    $0x2,%eax
  80013a:	89 d1                	mov    %edx,%ecx
  80013c:	89 d3                	mov    %edx,%ebx
  80013e:	89 d7                	mov    %edx,%edi
  800140:	89 d6                	mov    %edx,%esi
  800142:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5f                   	pop    %edi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <sys_yield>:

void
sys_yield(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	57                   	push   %edi
  80014d:	56                   	push   %esi
  80014e:	53                   	push   %ebx
    asm volatile("int %1\n"
  80014f:	ba 00 00 00 00       	mov    $0x0,%edx
  800154:	b8 0a 00 00 00       	mov    $0xa,%eax
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	89 d3                	mov    %edx,%ebx
  80015d:	89 d7                	mov    %edx,%edi
  80015f:	89 d6                	mov    %edx,%esi
  800161:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800163:	5b                   	pop    %ebx
  800164:	5e                   	pop    %esi
  800165:	5f                   	pop    %edi
  800166:	5d                   	pop    %ebp
  800167:	c3                   	ret    

00800168 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	57                   	push   %edi
  80016c:	56                   	push   %esi
  80016d:	53                   	push   %ebx
  80016e:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800171:	be 00 00 00 00       	mov    $0x0,%esi
  800176:	8b 55 08             	mov    0x8(%ebp),%edx
  800179:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017c:	b8 04 00 00 00       	mov    $0x4,%eax
  800181:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800184:	89 f7                	mov    %esi,%edi
  800186:	cd 30                	int    $0x30
    if (check && ret > 0)
  800188:	85 c0                	test   %eax,%eax
  80018a:	7f 08                	jg     800194 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018f:	5b                   	pop    %ebx
  800190:	5e                   	pop    %esi
  800191:	5f                   	pop    %edi
  800192:	5d                   	pop    %ebp
  800193:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800194:	83 ec 0c             	sub    $0xc,%esp
  800197:	50                   	push   %eax
  800198:	6a 04                	push   $0x4
  80019a:	68 6a 10 80 00       	push   $0x80106a
  80019f:	6a 24                	push   $0x24
  8001a1:	68 87 10 80 00       	push   $0x801087
  8001a6:	e8 92 01 00 00       	call   80033d <_panic>

008001ab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	57                   	push   %edi
  8001af:	56                   	push   %esi
  8001b0:	53                   	push   %ebx
  8001b1:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ba:	b8 05 00 00 00       	mov    $0x5,%eax
  8001bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c5:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c8:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	7f 08                	jg     8001d6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d1:	5b                   	pop    %ebx
  8001d2:	5e                   	pop    %esi
  8001d3:	5f                   	pop    %edi
  8001d4:	5d                   	pop    %ebp
  8001d5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	50                   	push   %eax
  8001da:	6a 05                	push   $0x5
  8001dc:	68 6a 10 80 00       	push   $0x80106a
  8001e1:	6a 24                	push   $0x24
  8001e3:	68 87 10 80 00       	push   $0x801087
  8001e8:	e8 50 01 00 00       	call   80033d <_panic>

008001ed <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	57                   	push   %edi
  8001f1:	56                   	push   %esi
  8001f2:	53                   	push   %ebx
  8001f3:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800201:	b8 06 00 00 00       	mov    $0x6,%eax
  800206:	89 df                	mov    %ebx,%edi
  800208:	89 de                	mov    %ebx,%esi
  80020a:	cd 30                	int    $0x30
    if (check && ret > 0)
  80020c:	85 c0                	test   %eax,%eax
  80020e:	7f 08                	jg     800218 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800213:	5b                   	pop    %ebx
  800214:	5e                   	pop    %esi
  800215:	5f                   	pop    %edi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	50                   	push   %eax
  80021c:	6a 06                	push   $0x6
  80021e:	68 6a 10 80 00       	push   $0x80106a
  800223:	6a 24                	push   $0x24
  800225:	68 87 10 80 00       	push   $0x801087
  80022a:	e8 0e 01 00 00       	call   80033d <_panic>

0080022f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	57                   	push   %edi
  800233:	56                   	push   %esi
  800234:	53                   	push   %ebx
  800235:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800238:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023d:	8b 55 08             	mov    0x8(%ebp),%edx
  800240:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800243:	b8 08 00 00 00       	mov    $0x8,%eax
  800248:	89 df                	mov    %ebx,%edi
  80024a:	89 de                	mov    %ebx,%esi
  80024c:	cd 30                	int    $0x30
    if (check && ret > 0)
  80024e:	85 c0                	test   %eax,%eax
  800250:	7f 08                	jg     80025a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800252:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800255:	5b                   	pop    %ebx
  800256:	5e                   	pop    %esi
  800257:	5f                   	pop    %edi
  800258:	5d                   	pop    %ebp
  800259:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	50                   	push   %eax
  80025e:	6a 08                	push   $0x8
  800260:	68 6a 10 80 00       	push   $0x80106a
  800265:	6a 24                	push   $0x24
  800267:	68 87 10 80 00       	push   $0x801087
  80026c:	e8 cc 00 00 00       	call   80033d <_panic>

00800271 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	57                   	push   %edi
  800275:	56                   	push   %esi
  800276:	53                   	push   %ebx
  800277:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80027a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027f:	8b 55 08             	mov    0x8(%ebp),%edx
  800282:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800285:	b8 09 00 00 00       	mov    $0x9,%eax
  80028a:	89 df                	mov    %ebx,%edi
  80028c:	89 de                	mov    %ebx,%esi
  80028e:	cd 30                	int    $0x30
    if (check && ret > 0)
  800290:	85 c0                	test   %eax,%eax
  800292:	7f 08                	jg     80029c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800294:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800297:	5b                   	pop    %ebx
  800298:	5e                   	pop    %esi
  800299:	5f                   	pop    %edi
  80029a:	5d                   	pop    %ebp
  80029b:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	50                   	push   %eax
  8002a0:	6a 09                	push   $0x9
  8002a2:	68 6a 10 80 00       	push   $0x80106a
  8002a7:	6a 24                	push   $0x24
  8002a9:	68 87 10 80 00       	push   $0x801087
  8002ae:	e8 8a 00 00 00       	call   80033d <_panic>

008002b3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	57                   	push   %edi
  8002b7:	56                   	push   %esi
  8002b8:	53                   	push   %ebx
    asm volatile("int %1\n"
  8002b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bf:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002c4:	be 00 00 00 00       	mov    $0x0,%esi
  8002c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002cc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002cf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002d1:	5b                   	pop    %ebx
  8002d2:	5e                   	pop    %esi
  8002d3:	5f                   	pop    %edi
  8002d4:	5d                   	pop    %ebp
  8002d5:	c3                   	ret    

008002d6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	57                   	push   %edi
  8002da:	56                   	push   %esi
  8002db:	53                   	push   %ebx
  8002dc:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ec:	89 cb                	mov    %ecx,%ebx
  8002ee:	89 cf                	mov    %ecx,%edi
  8002f0:	89 ce                	mov    %ecx,%esi
  8002f2:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002f4:	85 c0                	test   %eax,%eax
  8002f6:	7f 08                	jg     800300 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fb:	5b                   	pop    %ebx
  8002fc:	5e                   	pop    %esi
  8002fd:	5f                   	pop    %edi
  8002fe:	5d                   	pop    %ebp
  8002ff:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	50                   	push   %eax
  800304:	6a 0c                	push   $0xc
  800306:	68 6a 10 80 00       	push   $0x80106a
  80030b:	6a 24                	push   $0x24
  80030d:	68 87 10 80 00       	push   $0x801087
  800312:	e8 26 00 00 00       	call   80033d <_panic>

00800317 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800317:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800318:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  80031d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80031f:	83 c4 04             	add    $0x4,%esp
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

	//return EIP
	movl 0x28(%esp), %eax
  800322:	8b 44 24 28          	mov    0x28(%esp),%eax

	//original esp
	movl 0x30(%esp), %edx
  800326:	8b 54 24 30          	mov    0x30(%esp),%edx

	//original esp - 4
	subl $4, %edx
  80032a:	83 ea 04             	sub    $0x4,%edx

	//reserve return eip
	movl %eax, 0(%edx)
  80032d:	89 02                	mov    %eax,(%edx)

	//modify original esp
	movl %edx, 0x30(%esp)
  80032f:	89 54 24 30          	mov    %edx,0x30(%esp)

    addl $8, %esp
  800333:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
    popal
  800336:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
    addl $4, %esp
  800337:	83 c4 04             	add    $0x4,%esp
    popfl
  80033a:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
    popl %esp
  80033b:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80033c:	c3                   	ret    

0080033d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	56                   	push   %esi
  800341:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800342:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800345:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80034b:	e8 da fd ff ff       	call   80012a <sys_getenvid>
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	ff 75 0c             	pushl  0xc(%ebp)
  800356:	ff 75 08             	pushl  0x8(%ebp)
  800359:	56                   	push   %esi
  80035a:	50                   	push   %eax
  80035b:	68 98 10 80 00       	push   $0x801098
  800360:	e8 b3 00 00 00       	call   800418 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800365:	83 c4 18             	add    $0x18,%esp
  800368:	53                   	push   %ebx
  800369:	ff 75 10             	pushl  0x10(%ebp)
  80036c:	e8 56 00 00 00       	call   8003c7 <vcprintf>
	cprintf("\n");
  800371:	c7 04 24 bc 10 80 00 	movl   $0x8010bc,(%esp)
  800378:	e8 9b 00 00 00       	call   800418 <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800380:	cc                   	int3   
  800381:	eb fd                	jmp    800380 <_panic+0x43>

00800383 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	53                   	push   %ebx
  800387:	83 ec 04             	sub    $0x4,%esp
  80038a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80038d:	8b 13                	mov    (%ebx),%edx
  80038f:	8d 42 01             	lea    0x1(%edx),%eax
  800392:	89 03                	mov    %eax,(%ebx)
  800394:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800397:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80039b:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a0:	74 09                	je     8003ab <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003a2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a9:	c9                   	leave  
  8003aa:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	68 ff 00 00 00       	push   $0xff
  8003b3:	8d 43 08             	lea    0x8(%ebx),%eax
  8003b6:	50                   	push   %eax
  8003b7:	e8 f0 fc ff ff       	call   8000ac <sys_cputs>
		b->idx = 0;
  8003bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	eb db                	jmp    8003a2 <putch+0x1f>

008003c7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c7:	55                   	push   %ebp
  8003c8:	89 e5                	mov    %esp,%ebp
  8003ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003d7:	00 00 00 
	b.cnt = 0;
  8003da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003e1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003e4:	ff 75 0c             	pushl  0xc(%ebp)
  8003e7:	ff 75 08             	pushl  0x8(%ebp)
  8003ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f0:	50                   	push   %eax
  8003f1:	68 83 03 80 00       	push   $0x800383
  8003f6:	e8 1a 01 00 00       	call   800515 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003fb:	83 c4 08             	add    $0x8,%esp
  8003fe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800404:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80040a:	50                   	push   %eax
  80040b:	e8 9c fc ff ff       	call   8000ac <sys_cputs>

	return b.cnt;
}
  800410:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800416:	c9                   	leave  
  800417:	c3                   	ret    

00800418 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80041e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800421:	50                   	push   %eax
  800422:	ff 75 08             	pushl  0x8(%ebp)
  800425:	e8 9d ff ff ff       	call   8003c7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80042a:	c9                   	leave  
  80042b:	c3                   	ret    

0080042c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	57                   	push   %edi
  800430:	56                   	push   %esi
  800431:	53                   	push   %ebx
  800432:	83 ec 1c             	sub    $0x1c,%esp
  800435:	89 c7                	mov    %eax,%edi
  800437:	89 d6                	mov    %edx,%esi
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80043f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800442:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800445:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800448:	bb 00 00 00 00       	mov    $0x0,%ebx
  80044d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800450:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800453:	39 d3                	cmp    %edx,%ebx
  800455:	72 05                	jb     80045c <printnum+0x30>
  800457:	39 45 10             	cmp    %eax,0x10(%ebp)
  80045a:	77 7a                	ja     8004d6 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80045c:	83 ec 0c             	sub    $0xc,%esp
  80045f:	ff 75 18             	pushl  0x18(%ebp)
  800462:	8b 45 14             	mov    0x14(%ebp),%eax
  800465:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800468:	53                   	push   %ebx
  800469:	ff 75 10             	pushl  0x10(%ebp)
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800472:	ff 75 e0             	pushl  -0x20(%ebp)
  800475:	ff 75 dc             	pushl  -0x24(%ebp)
  800478:	ff 75 d8             	pushl  -0x28(%ebp)
  80047b:	e8 90 09 00 00       	call   800e10 <__udivdi3>
  800480:	83 c4 18             	add    $0x18,%esp
  800483:	52                   	push   %edx
  800484:	50                   	push   %eax
  800485:	89 f2                	mov    %esi,%edx
  800487:	89 f8                	mov    %edi,%eax
  800489:	e8 9e ff ff ff       	call   80042c <printnum>
  80048e:	83 c4 20             	add    $0x20,%esp
  800491:	eb 13                	jmp    8004a6 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	56                   	push   %esi
  800497:	ff 75 18             	pushl  0x18(%ebp)
  80049a:	ff d7                	call   *%edi
  80049c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80049f:	83 eb 01             	sub    $0x1,%ebx
  8004a2:	85 db                	test   %ebx,%ebx
  8004a4:	7f ed                	jg     800493 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	56                   	push   %esi
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b3:	ff 75 dc             	pushl  -0x24(%ebp)
  8004b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b9:	e8 72 0a 00 00       	call   800f30 <__umoddi3>
  8004be:	83 c4 14             	add    $0x14,%esp
  8004c1:	0f be 80 be 10 80 00 	movsbl 0x8010be(%eax),%eax
  8004c8:	50                   	push   %eax
  8004c9:	ff d7                	call   *%edi
}
  8004cb:	83 c4 10             	add    $0x10,%esp
  8004ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d1:	5b                   	pop    %ebx
  8004d2:	5e                   	pop    %esi
  8004d3:	5f                   	pop    %edi
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    
  8004d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004d9:	eb c4                	jmp    80049f <printnum+0x73>

008004db <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004e1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004e5:	8b 10                	mov    (%eax),%edx
  8004e7:	3b 50 04             	cmp    0x4(%eax),%edx
  8004ea:	73 0a                	jae    8004f6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004ec:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004ef:	89 08                	mov    %ecx,(%eax)
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	88 02                	mov    %al,(%edx)
}
  8004f6:	5d                   	pop    %ebp
  8004f7:	c3                   	ret    

008004f8 <printfmt>:
{
  8004f8:	55                   	push   %ebp
  8004f9:	89 e5                	mov    %esp,%ebp
  8004fb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004fe:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800501:	50                   	push   %eax
  800502:	ff 75 10             	pushl  0x10(%ebp)
  800505:	ff 75 0c             	pushl  0xc(%ebp)
  800508:	ff 75 08             	pushl  0x8(%ebp)
  80050b:	e8 05 00 00 00       	call   800515 <vprintfmt>
}
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	c9                   	leave  
  800514:	c3                   	ret    

00800515 <vprintfmt>:
{
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	57                   	push   %edi
  800519:	56                   	push   %esi
  80051a:	53                   	push   %ebx
  80051b:	83 ec 2c             	sub    $0x2c,%esp
  80051e:	8b 75 08             	mov    0x8(%ebp),%esi
  800521:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800524:	8b 7d 10             	mov    0x10(%ebp),%edi
  800527:	e9 00 04 00 00       	jmp    80092c <vprintfmt+0x417>
		padc = ' ';
  80052c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800530:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800537:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80053e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800545:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8d 47 01             	lea    0x1(%edi),%eax
  80054d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800550:	0f b6 17             	movzbl (%edi),%edx
  800553:	8d 42 dd             	lea    -0x23(%edx),%eax
  800556:	3c 55                	cmp    $0x55,%al
  800558:	0f 87 51 04 00 00    	ja     8009af <vprintfmt+0x49a>
  80055e:	0f b6 c0             	movzbl %al,%eax
  800561:	ff 24 85 80 11 80 00 	jmp    *0x801180(,%eax,4)
  800568:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80056b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80056f:	eb d9                	jmp    80054a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800571:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800574:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800578:	eb d0                	jmp    80054a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	0f b6 d2             	movzbl %dl,%edx
  80057d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800580:	b8 00 00 00 00       	mov    $0x0,%eax
  800585:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800588:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80058b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80058f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800592:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800595:	83 f9 09             	cmp    $0x9,%ecx
  800598:	77 55                	ja     8005ef <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80059a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80059d:	eb e9                	jmp    800588 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8d 40 04             	lea    0x4(%eax),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b7:	79 91                	jns    80054a <vprintfmt+0x35>
				width = precision, precision = -1;
  8005b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005bf:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005c6:	eb 82                	jmp    80054a <vprintfmt+0x35>
  8005c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005cb:	85 c0                	test   %eax,%eax
  8005cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d2:	0f 49 d0             	cmovns %eax,%edx
  8005d5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005db:	e9 6a ff ff ff       	jmp    80054a <vprintfmt+0x35>
  8005e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005e3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005ea:	e9 5b ff ff ff       	jmp    80054a <vprintfmt+0x35>
  8005ef:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f5:	eb bc                	jmp    8005b3 <vprintfmt+0x9e>
			lflag++;
  8005f7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005fd:	e9 48 ff ff ff       	jmp    80054a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	8d 78 04             	lea    0x4(%eax),%edi
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	53                   	push   %ebx
  80060c:	ff 30                	pushl  (%eax)
  80060e:	ff d6                	call   *%esi
			break;
  800610:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800613:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800616:	e9 0e 03 00 00       	jmp    800929 <vprintfmt+0x414>
			err = va_arg(ap, int);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8d 78 04             	lea    0x4(%eax),%edi
  800621:	8b 00                	mov    (%eax),%eax
  800623:	99                   	cltd   
  800624:	31 d0                	xor    %edx,%eax
  800626:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800628:	83 f8 08             	cmp    $0x8,%eax
  80062b:	7f 23                	jg     800650 <vprintfmt+0x13b>
  80062d:	8b 14 85 e0 12 80 00 	mov    0x8012e0(,%eax,4),%edx
  800634:	85 d2                	test   %edx,%edx
  800636:	74 18                	je     800650 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800638:	52                   	push   %edx
  800639:	68 df 10 80 00       	push   $0x8010df
  80063e:	53                   	push   %ebx
  80063f:	56                   	push   %esi
  800640:	e8 b3 fe ff ff       	call   8004f8 <printfmt>
  800645:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800648:	89 7d 14             	mov    %edi,0x14(%ebp)
  80064b:	e9 d9 02 00 00       	jmp    800929 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800650:	50                   	push   %eax
  800651:	68 d6 10 80 00       	push   $0x8010d6
  800656:	53                   	push   %ebx
  800657:	56                   	push   %esi
  800658:	e8 9b fe ff ff       	call   8004f8 <printfmt>
  80065d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800660:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800663:	e9 c1 02 00 00       	jmp    800929 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	83 c0 04             	add    $0x4,%eax
  80066e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800676:	85 ff                	test   %edi,%edi
  800678:	b8 cf 10 80 00       	mov    $0x8010cf,%eax
  80067d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800680:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800684:	0f 8e bd 00 00 00    	jle    800747 <vprintfmt+0x232>
  80068a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80068e:	75 0e                	jne    80069e <vprintfmt+0x189>
  800690:	89 75 08             	mov    %esi,0x8(%ebp)
  800693:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800696:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800699:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80069c:	eb 6d                	jmp    80070b <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80069e:	83 ec 08             	sub    $0x8,%esp
  8006a1:	ff 75 d0             	pushl  -0x30(%ebp)
  8006a4:	57                   	push   %edi
  8006a5:	e8 ad 03 00 00       	call   800a57 <strnlen>
  8006aa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006ad:	29 c1                	sub    %eax,%ecx
  8006af:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006b2:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006b5:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006bc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006bf:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c1:	eb 0f                	jmp    8006d2 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	53                   	push   %ebx
  8006c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ca:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cc:	83 ef 01             	sub    $0x1,%edi
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	85 ff                	test   %edi,%edi
  8006d4:	7f ed                	jg     8006c3 <vprintfmt+0x1ae>
  8006d6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006d9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006dc:	85 c9                	test   %ecx,%ecx
  8006de:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e3:	0f 49 c1             	cmovns %ecx,%eax
  8006e6:	29 c1                	sub    %eax,%ecx
  8006e8:	89 75 08             	mov    %esi,0x8(%ebp)
  8006eb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006ee:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006f1:	89 cb                	mov    %ecx,%ebx
  8006f3:	eb 16                	jmp    80070b <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006f9:	75 31                	jne    80072c <vprintfmt+0x217>
					putch(ch, putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	50                   	push   %eax
  800702:	ff 55 08             	call   *0x8(%ebp)
  800705:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800708:	83 eb 01             	sub    $0x1,%ebx
  80070b:	83 c7 01             	add    $0x1,%edi
  80070e:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800712:	0f be c2             	movsbl %dl,%eax
  800715:	85 c0                	test   %eax,%eax
  800717:	74 59                	je     800772 <vprintfmt+0x25d>
  800719:	85 f6                	test   %esi,%esi
  80071b:	78 d8                	js     8006f5 <vprintfmt+0x1e0>
  80071d:	83 ee 01             	sub    $0x1,%esi
  800720:	79 d3                	jns    8006f5 <vprintfmt+0x1e0>
  800722:	89 df                	mov    %ebx,%edi
  800724:	8b 75 08             	mov    0x8(%ebp),%esi
  800727:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80072a:	eb 37                	jmp    800763 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80072c:	0f be d2             	movsbl %dl,%edx
  80072f:	83 ea 20             	sub    $0x20,%edx
  800732:	83 fa 5e             	cmp    $0x5e,%edx
  800735:	76 c4                	jbe    8006fb <vprintfmt+0x1e6>
					putch('?', putdat);
  800737:	83 ec 08             	sub    $0x8,%esp
  80073a:	ff 75 0c             	pushl  0xc(%ebp)
  80073d:	6a 3f                	push   $0x3f
  80073f:	ff 55 08             	call   *0x8(%ebp)
  800742:	83 c4 10             	add    $0x10,%esp
  800745:	eb c1                	jmp    800708 <vprintfmt+0x1f3>
  800747:	89 75 08             	mov    %esi,0x8(%ebp)
  80074a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80074d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800750:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800753:	eb b6                	jmp    80070b <vprintfmt+0x1f6>
				putch(' ', putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	53                   	push   %ebx
  800759:	6a 20                	push   $0x20
  80075b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80075d:	83 ef 01             	sub    $0x1,%edi
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	85 ff                	test   %edi,%edi
  800765:	7f ee                	jg     800755 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800767:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
  80076d:	e9 b7 01 00 00       	jmp    800929 <vprintfmt+0x414>
  800772:	89 df                	mov    %ebx,%edi
  800774:	8b 75 08             	mov    0x8(%ebp),%esi
  800777:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80077a:	eb e7                	jmp    800763 <vprintfmt+0x24e>
	if (lflag >= 2)
  80077c:	83 f9 01             	cmp    $0x1,%ecx
  80077f:	7e 3f                	jle    8007c0 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 50 04             	mov    0x4(%eax),%edx
  800787:	8b 00                	mov    (%eax),%eax
  800789:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 40 08             	lea    0x8(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800798:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80079c:	79 5c                	jns    8007fa <vprintfmt+0x2e5>
				putch('-', putdat);
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	53                   	push   %ebx
  8007a2:	6a 2d                	push   $0x2d
  8007a4:	ff d6                	call   *%esi
				num = -(long long) num;
  8007a6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007ac:	f7 da                	neg    %edx
  8007ae:	83 d1 00             	adc    $0x0,%ecx
  8007b1:	f7 d9                	neg    %ecx
  8007b3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007bb:	e9 4f 01 00 00       	jmp    80090f <vprintfmt+0x3fa>
	else if (lflag)
  8007c0:	85 c9                	test   %ecx,%ecx
  8007c2:	75 1b                	jne    8007df <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cc:	89 c1                	mov    %eax,%ecx
  8007ce:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	8d 40 04             	lea    0x4(%eax),%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dd:	eb b9                	jmp    800798 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e7:	89 c1                	mov    %eax,%ecx
  8007e9:	c1 f9 1f             	sar    $0x1f,%ecx
  8007ec:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8d 40 04             	lea    0x4(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f8:	eb 9e                	jmp    800798 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007fa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007fd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800800:	b8 0a 00 00 00       	mov    $0xa,%eax
  800805:	e9 05 01 00 00       	jmp    80090f <vprintfmt+0x3fa>
	if (lflag >= 2)
  80080a:	83 f9 01             	cmp    $0x1,%ecx
  80080d:	7e 18                	jle    800827 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8b 10                	mov    (%eax),%edx
  800814:	8b 48 04             	mov    0x4(%eax),%ecx
  800817:	8d 40 08             	lea    0x8(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80081d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800822:	e9 e8 00 00 00       	jmp    80090f <vprintfmt+0x3fa>
	else if (lflag)
  800827:	85 c9                	test   %ecx,%ecx
  800829:	75 1a                	jne    800845 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8b 10                	mov    (%eax),%edx
  800830:	b9 00 00 00 00       	mov    $0x0,%ecx
  800835:	8d 40 04             	lea    0x4(%eax),%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80083b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800840:	e9 ca 00 00 00       	jmp    80090f <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	8b 10                	mov    (%eax),%edx
  80084a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80084f:	8d 40 04             	lea    0x4(%eax),%eax
  800852:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800855:	b8 0a 00 00 00       	mov    $0xa,%eax
  80085a:	e9 b0 00 00 00       	jmp    80090f <vprintfmt+0x3fa>
	if (lflag >= 2)
  80085f:	83 f9 01             	cmp    $0x1,%ecx
  800862:	7e 3c                	jle    8008a0 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8b 50 04             	mov    0x4(%eax),%edx
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	8d 40 08             	lea    0x8(%eax),%eax
  800878:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80087b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80087f:	79 59                	jns    8008da <vprintfmt+0x3c5>
                putch('-', putdat);
  800881:	83 ec 08             	sub    $0x8,%esp
  800884:	53                   	push   %ebx
  800885:	6a 2d                	push   $0x2d
  800887:	ff d6                	call   *%esi
                num = -(long long) num;
  800889:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80088c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80088f:	f7 da                	neg    %edx
  800891:	83 d1 00             	adc    $0x0,%ecx
  800894:	f7 d9                	neg    %ecx
  800896:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800899:	b8 08 00 00 00       	mov    $0x8,%eax
  80089e:	eb 6f                	jmp    80090f <vprintfmt+0x3fa>
	else if (lflag)
  8008a0:	85 c9                	test   %ecx,%ecx
  8008a2:	75 1b                	jne    8008bf <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ac:	89 c1                	mov    %eax,%ecx
  8008ae:	c1 f9 1f             	sar    $0x1f,%ecx
  8008b1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8d 40 04             	lea    0x4(%eax),%eax
  8008ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bd:	eb bc                	jmp    80087b <vprintfmt+0x366>
		return va_arg(*ap, long);
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c7:	89 c1                	mov    %eax,%ecx
  8008c9:	c1 f9 1f             	sar    $0x1f,%ecx
  8008cc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8d 40 04             	lea    0x4(%eax),%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	eb a1                	jmp    80087b <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8008da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008dd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8008e0:	b8 08 00 00 00       	mov    $0x8,%eax
  8008e5:	eb 28                	jmp    80090f <vprintfmt+0x3fa>
			putch('0', putdat);
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	53                   	push   %ebx
  8008eb:	6a 30                	push   $0x30
  8008ed:	ff d6                	call   *%esi
			putch('x', putdat);
  8008ef:	83 c4 08             	add    $0x8,%esp
  8008f2:	53                   	push   %ebx
  8008f3:	6a 78                	push   $0x78
  8008f5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fa:	8b 10                	mov    (%eax),%edx
  8008fc:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800901:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800904:	8d 40 04             	lea    0x4(%eax),%eax
  800907:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80090f:	83 ec 0c             	sub    $0xc,%esp
  800912:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800916:	57                   	push   %edi
  800917:	ff 75 e0             	pushl  -0x20(%ebp)
  80091a:	50                   	push   %eax
  80091b:	51                   	push   %ecx
  80091c:	52                   	push   %edx
  80091d:	89 da                	mov    %ebx,%edx
  80091f:	89 f0                	mov    %esi,%eax
  800921:	e8 06 fb ff ff       	call   80042c <printnum>
			break;
  800926:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800929:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092c:	83 c7 01             	add    $0x1,%edi
  80092f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800933:	83 f8 25             	cmp    $0x25,%eax
  800936:	0f 84 f0 fb ff ff    	je     80052c <vprintfmt+0x17>
			if (ch == '\0')
  80093c:	85 c0                	test   %eax,%eax
  80093e:	0f 84 8b 00 00 00    	je     8009cf <vprintfmt+0x4ba>
			putch(ch, putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	53                   	push   %ebx
  800948:	50                   	push   %eax
  800949:	ff d6                	call   *%esi
  80094b:	83 c4 10             	add    $0x10,%esp
  80094e:	eb dc                	jmp    80092c <vprintfmt+0x417>
	if (lflag >= 2)
  800950:	83 f9 01             	cmp    $0x1,%ecx
  800953:	7e 15                	jle    80096a <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	8b 10                	mov    (%eax),%edx
  80095a:	8b 48 04             	mov    0x4(%eax),%ecx
  80095d:	8d 40 08             	lea    0x8(%eax),%eax
  800960:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800963:	b8 10 00 00 00       	mov    $0x10,%eax
  800968:	eb a5                	jmp    80090f <vprintfmt+0x3fa>
	else if (lflag)
  80096a:	85 c9                	test   %ecx,%ecx
  80096c:	75 17                	jne    800985 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	8b 10                	mov    (%eax),%edx
  800973:	b9 00 00 00 00       	mov    $0x0,%ecx
  800978:	8d 40 04             	lea    0x4(%eax),%eax
  80097b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80097e:	b8 10 00 00 00       	mov    $0x10,%eax
  800983:	eb 8a                	jmp    80090f <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	8b 10                	mov    (%eax),%edx
  80098a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80098f:	8d 40 04             	lea    0x4(%eax),%eax
  800992:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800995:	b8 10 00 00 00       	mov    $0x10,%eax
  80099a:	e9 70 ff ff ff       	jmp    80090f <vprintfmt+0x3fa>
			putch(ch, putdat);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	53                   	push   %ebx
  8009a3:	6a 25                	push   $0x25
  8009a5:	ff d6                	call   *%esi
			break;
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	e9 7a ff ff ff       	jmp    800929 <vprintfmt+0x414>
			putch('%', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	53                   	push   %ebx
  8009b3:	6a 25                	push   $0x25
  8009b5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	89 f8                	mov    %edi,%eax
  8009bc:	eb 03                	jmp    8009c1 <vprintfmt+0x4ac>
  8009be:	83 e8 01             	sub    $0x1,%eax
  8009c1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009c5:	75 f7                	jne    8009be <vprintfmt+0x4a9>
  8009c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009ca:	e9 5a ff ff ff       	jmp    800929 <vprintfmt+0x414>
}
  8009cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009d2:	5b                   	pop    %ebx
  8009d3:	5e                   	pop    %esi
  8009d4:	5f                   	pop    %edi
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    

008009d7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	83 ec 18             	sub    $0x18,%esp
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009e6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009ea:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009f4:	85 c0                	test   %eax,%eax
  8009f6:	74 26                	je     800a1e <vsnprintf+0x47>
  8009f8:	85 d2                	test   %edx,%edx
  8009fa:	7e 22                	jle    800a1e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009fc:	ff 75 14             	pushl  0x14(%ebp)
  8009ff:	ff 75 10             	pushl  0x10(%ebp)
  800a02:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a05:	50                   	push   %eax
  800a06:	68 db 04 80 00       	push   $0x8004db
  800a0b:	e8 05 fb ff ff       	call   800515 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a13:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a19:	83 c4 10             	add    $0x10,%esp
}
  800a1c:	c9                   	leave  
  800a1d:	c3                   	ret    
		return -E_INVAL;
  800a1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a23:	eb f7                	jmp    800a1c <vsnprintf+0x45>

00800a25 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a2b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a2e:	50                   	push   %eax
  800a2f:	ff 75 10             	pushl  0x10(%ebp)
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	ff 75 08             	pushl  0x8(%ebp)
  800a38:	e8 9a ff ff ff       	call   8009d7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a3d:	c9                   	leave  
  800a3e:	c3                   	ret    

00800a3f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a45:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4a:	eb 03                	jmp    800a4f <strlen+0x10>
		n++;
  800a4c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a4f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a53:	75 f7                	jne    800a4c <strlen+0xd>
	return n;
}
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a60:	b8 00 00 00 00       	mov    $0x0,%eax
  800a65:	eb 03                	jmp    800a6a <strnlen+0x13>
		n++;
  800a67:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a6a:	39 d0                	cmp    %edx,%eax
  800a6c:	74 06                	je     800a74 <strnlen+0x1d>
  800a6e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a72:	75 f3                	jne    800a67 <strnlen+0x10>
	return n;
}
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	53                   	push   %ebx
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a80:	89 c2                	mov    %eax,%edx
  800a82:	83 c1 01             	add    $0x1,%ecx
  800a85:	83 c2 01             	add    $0x1,%edx
  800a88:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a8c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a8f:	84 db                	test   %bl,%bl
  800a91:	75 ef                	jne    800a82 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a93:	5b                   	pop    %ebx
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	53                   	push   %ebx
  800a9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a9d:	53                   	push   %ebx
  800a9e:	e8 9c ff ff ff       	call   800a3f <strlen>
  800aa3:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	01 d8                	add    %ebx,%eax
  800aab:	50                   	push   %eax
  800aac:	e8 c5 ff ff ff       	call   800a76 <strcpy>
	return dst;
}
  800ab1:	89 d8                	mov    %ebx,%eax
  800ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ab6:	c9                   	leave  
  800ab7:	c3                   	ret    

00800ab8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	56                   	push   %esi
  800abc:	53                   	push   %ebx
  800abd:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac3:	89 f3                	mov    %esi,%ebx
  800ac5:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ac8:	89 f2                	mov    %esi,%edx
  800aca:	eb 0f                	jmp    800adb <strncpy+0x23>
		*dst++ = *src;
  800acc:	83 c2 01             	add    $0x1,%edx
  800acf:	0f b6 01             	movzbl (%ecx),%eax
  800ad2:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ad5:	80 39 01             	cmpb   $0x1,(%ecx)
  800ad8:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800adb:	39 da                	cmp    %ebx,%edx
  800add:	75 ed                	jne    800acc <strncpy+0x14>
	}
	return ret;
}
  800adf:	89 f0                	mov    %esi,%eax
  800ae1:	5b                   	pop    %ebx
  800ae2:	5e                   	pop    %esi
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	56                   	push   %esi
  800ae9:	53                   	push   %ebx
  800aea:	8b 75 08             	mov    0x8(%ebp),%esi
  800aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800af3:	89 f0                	mov    %esi,%eax
  800af5:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800af9:	85 c9                	test   %ecx,%ecx
  800afb:	75 0b                	jne    800b08 <strlcpy+0x23>
  800afd:	eb 17                	jmp    800b16 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800aff:	83 c2 01             	add    $0x1,%edx
  800b02:	83 c0 01             	add    $0x1,%eax
  800b05:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800b08:	39 d8                	cmp    %ebx,%eax
  800b0a:	74 07                	je     800b13 <strlcpy+0x2e>
  800b0c:	0f b6 0a             	movzbl (%edx),%ecx
  800b0f:	84 c9                	test   %cl,%cl
  800b11:	75 ec                	jne    800aff <strlcpy+0x1a>
		*dst = '\0';
  800b13:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b16:	29 f0                	sub    %esi,%eax
}
  800b18:	5b                   	pop    %ebx
  800b19:	5e                   	pop    %esi
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b22:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b25:	eb 06                	jmp    800b2d <strcmp+0x11>
		p++, q++;
  800b27:	83 c1 01             	add    $0x1,%ecx
  800b2a:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b2d:	0f b6 01             	movzbl (%ecx),%eax
  800b30:	84 c0                	test   %al,%al
  800b32:	74 04                	je     800b38 <strcmp+0x1c>
  800b34:	3a 02                	cmp    (%edx),%al
  800b36:	74 ef                	je     800b27 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b38:	0f b6 c0             	movzbl %al,%eax
  800b3b:	0f b6 12             	movzbl (%edx),%edx
  800b3e:	29 d0                	sub    %edx,%eax
}
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	53                   	push   %ebx
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4c:	89 c3                	mov    %eax,%ebx
  800b4e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b51:	eb 06                	jmp    800b59 <strncmp+0x17>
		n--, p++, q++;
  800b53:	83 c0 01             	add    $0x1,%eax
  800b56:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b59:	39 d8                	cmp    %ebx,%eax
  800b5b:	74 16                	je     800b73 <strncmp+0x31>
  800b5d:	0f b6 08             	movzbl (%eax),%ecx
  800b60:	84 c9                	test   %cl,%cl
  800b62:	74 04                	je     800b68 <strncmp+0x26>
  800b64:	3a 0a                	cmp    (%edx),%cl
  800b66:	74 eb                	je     800b53 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b68:	0f b6 00             	movzbl (%eax),%eax
  800b6b:	0f b6 12             	movzbl (%edx),%edx
  800b6e:	29 d0                	sub    %edx,%eax
}
  800b70:	5b                   	pop    %ebx
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    
		return 0;
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	eb f6                	jmp    800b70 <strncmp+0x2e>

00800b7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b84:	0f b6 10             	movzbl (%eax),%edx
  800b87:	84 d2                	test   %dl,%dl
  800b89:	74 09                	je     800b94 <strchr+0x1a>
		if (*s == c)
  800b8b:	38 ca                	cmp    %cl,%dl
  800b8d:	74 0a                	je     800b99 <strchr+0x1f>
	for (; *s; s++)
  800b8f:	83 c0 01             	add    $0x1,%eax
  800b92:	eb f0                	jmp    800b84 <strchr+0xa>
			return (char *) s;
	return 0;
  800b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    

00800b9b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ba5:	eb 03                	jmp    800baa <strfind+0xf>
  800ba7:	83 c0 01             	add    $0x1,%eax
  800baa:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bad:	38 ca                	cmp    %cl,%dl
  800baf:	74 04                	je     800bb5 <strfind+0x1a>
  800bb1:	84 d2                	test   %dl,%dl
  800bb3:	75 f2                	jne    800ba7 <strfind+0xc>
			break;
	return (char *) s;
}
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	57                   	push   %edi
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bc0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bc3:	85 c9                	test   %ecx,%ecx
  800bc5:	74 13                	je     800bda <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bc7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bcd:	75 05                	jne    800bd4 <memset+0x1d>
  800bcf:	f6 c1 03             	test   $0x3,%cl
  800bd2:	74 0d                	je     800be1 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	fc                   	cld    
  800bd8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bda:	89 f8                	mov    %edi,%eax
  800bdc:	5b                   	pop    %ebx
  800bdd:	5e                   	pop    %esi
  800bde:	5f                   	pop    %edi
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    
		c &= 0xFF;
  800be1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800be5:	89 d3                	mov    %edx,%ebx
  800be7:	c1 e3 08             	shl    $0x8,%ebx
  800bea:	89 d0                	mov    %edx,%eax
  800bec:	c1 e0 18             	shl    $0x18,%eax
  800bef:	89 d6                	mov    %edx,%esi
  800bf1:	c1 e6 10             	shl    $0x10,%esi
  800bf4:	09 f0                	or     %esi,%eax
  800bf6:	09 c2                	or     %eax,%edx
  800bf8:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bfa:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bfd:	89 d0                	mov    %edx,%eax
  800bff:	fc                   	cld    
  800c00:	f3 ab                	rep stos %eax,%es:(%edi)
  800c02:	eb d6                	jmp    800bda <memset+0x23>

00800c04 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	57                   	push   %edi
  800c08:	56                   	push   %esi
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c12:	39 c6                	cmp    %eax,%esi
  800c14:	73 35                	jae    800c4b <memmove+0x47>
  800c16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c19:	39 c2                	cmp    %eax,%edx
  800c1b:	76 2e                	jbe    800c4b <memmove+0x47>
		s += n;
		d += n;
  800c1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c20:	89 d6                	mov    %edx,%esi
  800c22:	09 fe                	or     %edi,%esi
  800c24:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c2a:	74 0c                	je     800c38 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c2c:	83 ef 01             	sub    $0x1,%edi
  800c2f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c32:	fd                   	std    
  800c33:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c35:	fc                   	cld    
  800c36:	eb 21                	jmp    800c59 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c38:	f6 c1 03             	test   $0x3,%cl
  800c3b:	75 ef                	jne    800c2c <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c3d:	83 ef 04             	sub    $0x4,%edi
  800c40:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c43:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c46:	fd                   	std    
  800c47:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c49:	eb ea                	jmp    800c35 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c4b:	89 f2                	mov    %esi,%edx
  800c4d:	09 c2                	or     %eax,%edx
  800c4f:	f6 c2 03             	test   $0x3,%dl
  800c52:	74 09                	je     800c5d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c54:	89 c7                	mov    %eax,%edi
  800c56:	fc                   	cld    
  800c57:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c59:	5e                   	pop    %esi
  800c5a:	5f                   	pop    %edi
  800c5b:	5d                   	pop    %ebp
  800c5c:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c5d:	f6 c1 03             	test   $0x3,%cl
  800c60:	75 f2                	jne    800c54 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c62:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c65:	89 c7                	mov    %eax,%edi
  800c67:	fc                   	cld    
  800c68:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c6a:	eb ed                	jmp    800c59 <memmove+0x55>

00800c6c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c6f:	ff 75 10             	pushl  0x10(%ebp)
  800c72:	ff 75 0c             	pushl  0xc(%ebp)
  800c75:	ff 75 08             	pushl  0x8(%ebp)
  800c78:	e8 87 ff ff ff       	call   800c04 <memmove>
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8a:	89 c6                	mov    %eax,%esi
  800c8c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c8f:	39 f0                	cmp    %esi,%eax
  800c91:	74 1c                	je     800caf <memcmp+0x30>
		if (*s1 != *s2)
  800c93:	0f b6 08             	movzbl (%eax),%ecx
  800c96:	0f b6 1a             	movzbl (%edx),%ebx
  800c99:	38 d9                	cmp    %bl,%cl
  800c9b:	75 08                	jne    800ca5 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c9d:	83 c0 01             	add    $0x1,%eax
  800ca0:	83 c2 01             	add    $0x1,%edx
  800ca3:	eb ea                	jmp    800c8f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ca5:	0f b6 c1             	movzbl %cl,%eax
  800ca8:	0f b6 db             	movzbl %bl,%ebx
  800cab:	29 d8                	sub    %ebx,%eax
  800cad:	eb 05                	jmp    800cb4 <memcmp+0x35>
	}

	return 0;
  800caf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb4:	5b                   	pop    %ebx
  800cb5:	5e                   	pop    %esi
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    

00800cb8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cc1:	89 c2                	mov    %eax,%edx
  800cc3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cc6:	39 d0                	cmp    %edx,%eax
  800cc8:	73 09                	jae    800cd3 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cca:	38 08                	cmp    %cl,(%eax)
  800ccc:	74 05                	je     800cd3 <memfind+0x1b>
	for (; s < ends; s++)
  800cce:	83 c0 01             	add    $0x1,%eax
  800cd1:	eb f3                	jmp    800cc6 <memfind+0xe>
			break;
	return (void *) s;
}
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	57                   	push   %edi
  800cd9:	56                   	push   %esi
  800cda:	53                   	push   %ebx
  800cdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cde:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ce1:	eb 03                	jmp    800ce6 <strtol+0x11>
		s++;
  800ce3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ce6:	0f b6 01             	movzbl (%ecx),%eax
  800ce9:	3c 20                	cmp    $0x20,%al
  800ceb:	74 f6                	je     800ce3 <strtol+0xe>
  800ced:	3c 09                	cmp    $0x9,%al
  800cef:	74 f2                	je     800ce3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cf1:	3c 2b                	cmp    $0x2b,%al
  800cf3:	74 2e                	je     800d23 <strtol+0x4e>
	int neg = 0;
  800cf5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cfa:	3c 2d                	cmp    $0x2d,%al
  800cfc:	74 2f                	je     800d2d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cfe:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d04:	75 05                	jne    800d0b <strtol+0x36>
  800d06:	80 39 30             	cmpb   $0x30,(%ecx)
  800d09:	74 2c                	je     800d37 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d0b:	85 db                	test   %ebx,%ebx
  800d0d:	75 0a                	jne    800d19 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d0f:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800d14:	80 39 30             	cmpb   $0x30,(%ecx)
  800d17:	74 28                	je     800d41 <strtol+0x6c>
		base = 10;
  800d19:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d21:	eb 50                	jmp    800d73 <strtol+0x9e>
		s++;
  800d23:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d26:	bf 00 00 00 00       	mov    $0x0,%edi
  800d2b:	eb d1                	jmp    800cfe <strtol+0x29>
		s++, neg = 1;
  800d2d:	83 c1 01             	add    $0x1,%ecx
  800d30:	bf 01 00 00 00       	mov    $0x1,%edi
  800d35:	eb c7                	jmp    800cfe <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d37:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d3b:	74 0e                	je     800d4b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d3d:	85 db                	test   %ebx,%ebx
  800d3f:	75 d8                	jne    800d19 <strtol+0x44>
		s++, base = 8;
  800d41:	83 c1 01             	add    $0x1,%ecx
  800d44:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d49:	eb ce                	jmp    800d19 <strtol+0x44>
		s += 2, base = 16;
  800d4b:	83 c1 02             	add    $0x2,%ecx
  800d4e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d53:	eb c4                	jmp    800d19 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d55:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d58:	89 f3                	mov    %esi,%ebx
  800d5a:	80 fb 19             	cmp    $0x19,%bl
  800d5d:	77 29                	ja     800d88 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d5f:	0f be d2             	movsbl %dl,%edx
  800d62:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d65:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d68:	7d 30                	jge    800d9a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d6a:	83 c1 01             	add    $0x1,%ecx
  800d6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d71:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d73:	0f b6 11             	movzbl (%ecx),%edx
  800d76:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d79:	89 f3                	mov    %esi,%ebx
  800d7b:	80 fb 09             	cmp    $0x9,%bl
  800d7e:	77 d5                	ja     800d55 <strtol+0x80>
			dig = *s - '0';
  800d80:	0f be d2             	movsbl %dl,%edx
  800d83:	83 ea 30             	sub    $0x30,%edx
  800d86:	eb dd                	jmp    800d65 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d88:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d8b:	89 f3                	mov    %esi,%ebx
  800d8d:	80 fb 19             	cmp    $0x19,%bl
  800d90:	77 08                	ja     800d9a <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d92:	0f be d2             	movsbl %dl,%edx
  800d95:	83 ea 37             	sub    $0x37,%edx
  800d98:	eb cb                	jmp    800d65 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9e:	74 05                	je     800da5 <strtol+0xd0>
		*endptr = (char *) s;
  800da0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800da3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	f7 da                	neg    %edx
  800da9:	85 ff                	test   %edi,%edi
  800dab:	0f 45 c2             	cmovne %edx,%eax
}
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800db9:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800dc0:	74 0a                	je     800dcc <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    
        sys_page_alloc(ENVX(thisenv->env_id) , (void *)UXSTACKTOP - PGSIZE, PTE_W | PTE_U | PTE_P);
  800dcc:	a1 04 20 80 00       	mov    0x802004,%eax
  800dd1:	8b 40 48             	mov    0x48(%eax),%eax
  800dd4:	83 ec 04             	sub    $0x4,%esp
  800dd7:	6a 07                	push   $0x7
  800dd9:	68 00 f0 bf ee       	push   $0xeebff000
  800dde:	25 ff 03 00 00       	and    $0x3ff,%eax
  800de3:	50                   	push   %eax
  800de4:	e8 7f f3 ff ff       	call   800168 <sys_page_alloc>
        sys_env_set_pgfault_upcall(ENVX(thisenv->env_id), _pgfault_upcall);
  800de9:	a1 04 20 80 00       	mov    0x802004,%eax
  800dee:	8b 40 48             	mov    0x48(%eax),%eax
  800df1:	83 c4 08             	add    $0x8,%esp
  800df4:	68 17 03 80 00       	push   $0x800317
  800df9:	25 ff 03 00 00       	and    $0x3ff,%eax
  800dfe:	50                   	push   %eax
  800dff:	e8 6d f4 ff ff       	call   800271 <sys_env_set_pgfault_upcall>
  800e04:	83 c4 10             	add    $0x10,%esp
  800e07:	eb b9                	jmp    800dc2 <set_pgfault_handler+0xf>
  800e09:	66 90                	xchg   %ax,%ax
  800e0b:	66 90                	xchg   %ax,%ax
  800e0d:	66 90                	xchg   %ax,%ax
  800e0f:	90                   	nop

00800e10 <__udivdi3>:
  800e10:	55                   	push   %ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
  800e14:	83 ec 1c             	sub    $0x1c,%esp
  800e17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e27:	85 d2                	test   %edx,%edx
  800e29:	75 35                	jne    800e60 <__udivdi3+0x50>
  800e2b:	39 f3                	cmp    %esi,%ebx
  800e2d:	0f 87 bd 00 00 00    	ja     800ef0 <__udivdi3+0xe0>
  800e33:	85 db                	test   %ebx,%ebx
  800e35:	89 d9                	mov    %ebx,%ecx
  800e37:	75 0b                	jne    800e44 <__udivdi3+0x34>
  800e39:	b8 01 00 00 00       	mov    $0x1,%eax
  800e3e:	31 d2                	xor    %edx,%edx
  800e40:	f7 f3                	div    %ebx
  800e42:	89 c1                	mov    %eax,%ecx
  800e44:	31 d2                	xor    %edx,%edx
  800e46:	89 f0                	mov    %esi,%eax
  800e48:	f7 f1                	div    %ecx
  800e4a:	89 c6                	mov    %eax,%esi
  800e4c:	89 e8                	mov    %ebp,%eax
  800e4e:	89 f7                	mov    %esi,%edi
  800e50:	f7 f1                	div    %ecx
  800e52:	89 fa                	mov    %edi,%edx
  800e54:	83 c4 1c             	add    $0x1c,%esp
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    
  800e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e60:	39 f2                	cmp    %esi,%edx
  800e62:	77 7c                	ja     800ee0 <__udivdi3+0xd0>
  800e64:	0f bd fa             	bsr    %edx,%edi
  800e67:	83 f7 1f             	xor    $0x1f,%edi
  800e6a:	0f 84 98 00 00 00    	je     800f08 <__udivdi3+0xf8>
  800e70:	89 f9                	mov    %edi,%ecx
  800e72:	b8 20 00 00 00       	mov    $0x20,%eax
  800e77:	29 f8                	sub    %edi,%eax
  800e79:	d3 e2                	shl    %cl,%edx
  800e7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e7f:	89 c1                	mov    %eax,%ecx
  800e81:	89 da                	mov    %ebx,%edx
  800e83:	d3 ea                	shr    %cl,%edx
  800e85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e89:	09 d1                	or     %edx,%ecx
  800e8b:	89 f2                	mov    %esi,%edx
  800e8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e91:	89 f9                	mov    %edi,%ecx
  800e93:	d3 e3                	shl    %cl,%ebx
  800e95:	89 c1                	mov    %eax,%ecx
  800e97:	d3 ea                	shr    %cl,%edx
  800e99:	89 f9                	mov    %edi,%ecx
  800e9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e9f:	d3 e6                	shl    %cl,%esi
  800ea1:	89 eb                	mov    %ebp,%ebx
  800ea3:	89 c1                	mov    %eax,%ecx
  800ea5:	d3 eb                	shr    %cl,%ebx
  800ea7:	09 de                	or     %ebx,%esi
  800ea9:	89 f0                	mov    %esi,%eax
  800eab:	f7 74 24 08          	divl   0x8(%esp)
  800eaf:	89 d6                	mov    %edx,%esi
  800eb1:	89 c3                	mov    %eax,%ebx
  800eb3:	f7 64 24 0c          	mull   0xc(%esp)
  800eb7:	39 d6                	cmp    %edx,%esi
  800eb9:	72 0c                	jb     800ec7 <__udivdi3+0xb7>
  800ebb:	89 f9                	mov    %edi,%ecx
  800ebd:	d3 e5                	shl    %cl,%ebp
  800ebf:	39 c5                	cmp    %eax,%ebp
  800ec1:	73 5d                	jae    800f20 <__udivdi3+0x110>
  800ec3:	39 d6                	cmp    %edx,%esi
  800ec5:	75 59                	jne    800f20 <__udivdi3+0x110>
  800ec7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800eca:	31 ff                	xor    %edi,%edi
  800ecc:	89 fa                	mov    %edi,%edx
  800ece:	83 c4 1c             	add    $0x1c,%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    
  800ed6:	8d 76 00             	lea    0x0(%esi),%esi
  800ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800ee0:	31 ff                	xor    %edi,%edi
  800ee2:	31 c0                	xor    %eax,%eax
  800ee4:	89 fa                	mov    %edi,%edx
  800ee6:	83 c4 1c             	add    $0x1c,%esp
  800ee9:	5b                   	pop    %ebx
  800eea:	5e                   	pop    %esi
  800eeb:	5f                   	pop    %edi
  800eec:	5d                   	pop    %ebp
  800eed:	c3                   	ret    
  800eee:	66 90                	xchg   %ax,%ax
  800ef0:	31 ff                	xor    %edi,%edi
  800ef2:	89 e8                	mov    %ebp,%eax
  800ef4:	89 f2                	mov    %esi,%edx
  800ef6:	f7 f3                	div    %ebx
  800ef8:	89 fa                	mov    %edi,%edx
  800efa:	83 c4 1c             	add    $0x1c,%esp
  800efd:	5b                   	pop    %ebx
  800efe:	5e                   	pop    %esi
  800eff:	5f                   	pop    %edi
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    
  800f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f08:	39 f2                	cmp    %esi,%edx
  800f0a:	72 06                	jb     800f12 <__udivdi3+0x102>
  800f0c:	31 c0                	xor    %eax,%eax
  800f0e:	39 eb                	cmp    %ebp,%ebx
  800f10:	77 d2                	ja     800ee4 <__udivdi3+0xd4>
  800f12:	b8 01 00 00 00       	mov    $0x1,%eax
  800f17:	eb cb                	jmp    800ee4 <__udivdi3+0xd4>
  800f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f20:	89 d8                	mov    %ebx,%eax
  800f22:	31 ff                	xor    %edi,%edi
  800f24:	eb be                	jmp    800ee4 <__udivdi3+0xd4>
  800f26:	66 90                	xchg   %ax,%ax
  800f28:	66 90                	xchg   %ax,%ax
  800f2a:	66 90                	xchg   %ax,%ax
  800f2c:	66 90                	xchg   %ax,%ax
  800f2e:	66 90                	xchg   %ax,%ax

00800f30 <__umoddi3>:
  800f30:	55                   	push   %ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	83 ec 1c             	sub    $0x1c,%esp
  800f37:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800f3b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f3f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f47:	85 ed                	test   %ebp,%ebp
  800f49:	89 f0                	mov    %esi,%eax
  800f4b:	89 da                	mov    %ebx,%edx
  800f4d:	75 19                	jne    800f68 <__umoddi3+0x38>
  800f4f:	39 df                	cmp    %ebx,%edi
  800f51:	0f 86 b1 00 00 00    	jbe    801008 <__umoddi3+0xd8>
  800f57:	f7 f7                	div    %edi
  800f59:	89 d0                	mov    %edx,%eax
  800f5b:	31 d2                	xor    %edx,%edx
  800f5d:	83 c4 1c             	add    $0x1c,%esp
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    
  800f65:	8d 76 00             	lea    0x0(%esi),%esi
  800f68:	39 dd                	cmp    %ebx,%ebp
  800f6a:	77 f1                	ja     800f5d <__umoddi3+0x2d>
  800f6c:	0f bd cd             	bsr    %ebp,%ecx
  800f6f:	83 f1 1f             	xor    $0x1f,%ecx
  800f72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f76:	0f 84 b4 00 00 00    	je     801030 <__umoddi3+0x100>
  800f7c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f81:	89 c2                	mov    %eax,%edx
  800f83:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f87:	29 c2                	sub    %eax,%edx
  800f89:	89 c1                	mov    %eax,%ecx
  800f8b:	89 f8                	mov    %edi,%eax
  800f8d:	d3 e5                	shl    %cl,%ebp
  800f8f:	89 d1                	mov    %edx,%ecx
  800f91:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f95:	d3 e8                	shr    %cl,%eax
  800f97:	09 c5                	or     %eax,%ebp
  800f99:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f9d:	89 c1                	mov    %eax,%ecx
  800f9f:	d3 e7                	shl    %cl,%edi
  800fa1:	89 d1                	mov    %edx,%ecx
  800fa3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800fa7:	89 df                	mov    %ebx,%edi
  800fa9:	d3 ef                	shr    %cl,%edi
  800fab:	89 c1                	mov    %eax,%ecx
  800fad:	89 f0                	mov    %esi,%eax
  800faf:	d3 e3                	shl    %cl,%ebx
  800fb1:	89 d1                	mov    %edx,%ecx
  800fb3:	89 fa                	mov    %edi,%edx
  800fb5:	d3 e8                	shr    %cl,%eax
  800fb7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fbc:	09 d8                	or     %ebx,%eax
  800fbe:	f7 f5                	div    %ebp
  800fc0:	d3 e6                	shl    %cl,%esi
  800fc2:	89 d1                	mov    %edx,%ecx
  800fc4:	f7 64 24 08          	mull   0x8(%esp)
  800fc8:	39 d1                	cmp    %edx,%ecx
  800fca:	89 c3                	mov    %eax,%ebx
  800fcc:	89 d7                	mov    %edx,%edi
  800fce:	72 06                	jb     800fd6 <__umoddi3+0xa6>
  800fd0:	75 0e                	jne    800fe0 <__umoddi3+0xb0>
  800fd2:	39 c6                	cmp    %eax,%esi
  800fd4:	73 0a                	jae    800fe0 <__umoddi3+0xb0>
  800fd6:	2b 44 24 08          	sub    0x8(%esp),%eax
  800fda:	19 ea                	sbb    %ebp,%edx
  800fdc:	89 d7                	mov    %edx,%edi
  800fde:	89 c3                	mov    %eax,%ebx
  800fe0:	89 ca                	mov    %ecx,%edx
  800fe2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800fe7:	29 de                	sub    %ebx,%esi
  800fe9:	19 fa                	sbb    %edi,%edx
  800feb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800fef:	89 d0                	mov    %edx,%eax
  800ff1:	d3 e0                	shl    %cl,%eax
  800ff3:	89 d9                	mov    %ebx,%ecx
  800ff5:	d3 ee                	shr    %cl,%esi
  800ff7:	d3 ea                	shr    %cl,%edx
  800ff9:	09 f0                	or     %esi,%eax
  800ffb:	83 c4 1c             	add    $0x1c,%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    
  801003:	90                   	nop
  801004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801008:	85 ff                	test   %edi,%edi
  80100a:	89 f9                	mov    %edi,%ecx
  80100c:	75 0b                	jne    801019 <__umoddi3+0xe9>
  80100e:	b8 01 00 00 00       	mov    $0x1,%eax
  801013:	31 d2                	xor    %edx,%edx
  801015:	f7 f7                	div    %edi
  801017:	89 c1                	mov    %eax,%ecx
  801019:	89 d8                	mov    %ebx,%eax
  80101b:	31 d2                	xor    %edx,%edx
  80101d:	f7 f1                	div    %ecx
  80101f:	89 f0                	mov    %esi,%eax
  801021:	f7 f1                	div    %ecx
  801023:	e9 31 ff ff ff       	jmp    800f59 <__umoddi3+0x29>
  801028:	90                   	nop
  801029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801030:	39 dd                	cmp    %ebx,%ebp
  801032:	72 08                	jb     80103c <__umoddi3+0x10c>
  801034:	39 f7                	cmp    %esi,%edi
  801036:	0f 87 21 ff ff ff    	ja     800f5d <__umoddi3+0x2d>
  80103c:	89 da                	mov    %ebx,%edx
  80103e:	89 f0                	mov    %esi,%eax
  801040:	29 f8                	sub    %edi,%eax
  801042:	19 ea                	sbb    %ebp,%edx
  801044:	e9 14 ff ff ff       	jmp    800f5d <__umoddi3+0x2d>
