
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
  800119:	68 2a 10 80 00       	push   $0x80102a
  80011e:	6a 24                	push   $0x24
  800120:	68 47 10 80 00       	push   $0x801047
  800125:	e8 f8 01 00 00       	call   800322 <_panic>

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
  80019a:	68 2a 10 80 00       	push   $0x80102a
  80019f:	6a 24                	push   $0x24
  8001a1:	68 47 10 80 00       	push   $0x801047
  8001a6:	e8 77 01 00 00       	call   800322 <_panic>

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
  8001dc:	68 2a 10 80 00       	push   $0x80102a
  8001e1:	6a 24                	push   $0x24
  8001e3:	68 47 10 80 00       	push   $0x801047
  8001e8:	e8 35 01 00 00       	call   800322 <_panic>

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
  80021e:	68 2a 10 80 00       	push   $0x80102a
  800223:	6a 24                	push   $0x24
  800225:	68 47 10 80 00       	push   $0x801047
  80022a:	e8 f3 00 00 00       	call   800322 <_panic>

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
  800260:	68 2a 10 80 00       	push   $0x80102a
  800265:	6a 24                	push   $0x24
  800267:	68 47 10 80 00       	push   $0x801047
  80026c:	e8 b1 00 00 00       	call   800322 <_panic>

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
  8002a2:	68 2a 10 80 00       	push   $0x80102a
  8002a7:	6a 24                	push   $0x24
  8002a9:	68 47 10 80 00       	push   $0x801047
  8002ae:	e8 6f 00 00 00       	call   800322 <_panic>

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
  800306:	68 2a 10 80 00       	push   $0x80102a
  80030b:	6a 24                	push   $0x24
  80030d:	68 47 10 80 00       	push   $0x801047
  800312:	e8 0b 00 00 00       	call   800322 <_panic>

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

00800322 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	56                   	push   %esi
  800326:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800327:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80032a:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800330:	e8 f5 fd ff ff       	call   80012a <sys_getenvid>
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	ff 75 0c             	pushl  0xc(%ebp)
  80033b:	ff 75 08             	pushl  0x8(%ebp)
  80033e:	56                   	push   %esi
  80033f:	50                   	push   %eax
  800340:	68 58 10 80 00       	push   $0x801058
  800345:	e8 b3 00 00 00       	call   8003fd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80034a:	83 c4 18             	add    $0x18,%esp
  80034d:	53                   	push   %ebx
  80034e:	ff 75 10             	pushl  0x10(%ebp)
  800351:	e8 56 00 00 00       	call   8003ac <vcprintf>
	cprintf("\n");
  800356:	c7 04 24 7b 10 80 00 	movl   $0x80107b,(%esp)
  80035d:	e8 9b 00 00 00       	call   8003fd <cprintf>
  800362:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800365:	cc                   	int3   
  800366:	eb fd                	jmp    800365 <_panic+0x43>

00800368 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	53                   	push   %ebx
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800372:	8b 13                	mov    (%ebx),%edx
  800374:	8d 42 01             	lea    0x1(%edx),%eax
  800377:	89 03                	mov    %eax,(%ebx)
  800379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80037c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800380:	3d ff 00 00 00       	cmp    $0xff,%eax
  800385:	74 09                	je     800390 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800387:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80038b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	68 ff 00 00 00       	push   $0xff
  800398:	8d 43 08             	lea    0x8(%ebx),%eax
  80039b:	50                   	push   %eax
  80039c:	e8 0b fd ff ff       	call   8000ac <sys_cputs>
		b->idx = 0;
  8003a1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	eb db                	jmp    800387 <putch+0x1f>

008003ac <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003b5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003bc:	00 00 00 
	b.cnt = 0;
  8003bf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003c6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003c9:	ff 75 0c             	pushl  0xc(%ebp)
  8003cc:	ff 75 08             	pushl  0x8(%ebp)
  8003cf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d5:	50                   	push   %eax
  8003d6:	68 68 03 80 00       	push   $0x800368
  8003db:	e8 1a 01 00 00       	call   8004fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003e0:	83 c4 08             	add    $0x8,%esp
  8003e3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003e9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003ef:	50                   	push   %eax
  8003f0:	e8 b7 fc ff ff       	call   8000ac <sys_cputs>

	return b.cnt;
}
  8003f5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003fb:	c9                   	leave  
  8003fc:	c3                   	ret    

008003fd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800403:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800406:	50                   	push   %eax
  800407:	ff 75 08             	pushl  0x8(%ebp)
  80040a:	e8 9d ff ff ff       	call   8003ac <vcprintf>
	va_end(ap);

	return cnt;
}
  80040f:	c9                   	leave  
  800410:	c3                   	ret    

00800411 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800411:	55                   	push   %ebp
  800412:	89 e5                	mov    %esp,%ebp
  800414:	57                   	push   %edi
  800415:	56                   	push   %esi
  800416:	53                   	push   %ebx
  800417:	83 ec 1c             	sub    $0x1c,%esp
  80041a:	89 c7                	mov    %eax,%edi
  80041c:	89 d6                	mov    %edx,%esi
  80041e:	8b 45 08             	mov    0x8(%ebp),%eax
  800421:	8b 55 0c             	mov    0xc(%ebp),%edx
  800424:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800427:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80042a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80042d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800432:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800435:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800438:	39 d3                	cmp    %edx,%ebx
  80043a:	72 05                	jb     800441 <printnum+0x30>
  80043c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80043f:	77 7a                	ja     8004bb <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800441:	83 ec 0c             	sub    $0xc,%esp
  800444:	ff 75 18             	pushl  0x18(%ebp)
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80044d:	53                   	push   %ebx
  80044e:	ff 75 10             	pushl  0x10(%ebp)
  800451:	83 ec 08             	sub    $0x8,%esp
  800454:	ff 75 e4             	pushl  -0x1c(%ebp)
  800457:	ff 75 e0             	pushl  -0x20(%ebp)
  80045a:	ff 75 dc             	pushl  -0x24(%ebp)
  80045d:	ff 75 d8             	pushl  -0x28(%ebp)
  800460:	e8 6b 09 00 00       	call   800dd0 <__udivdi3>
  800465:	83 c4 18             	add    $0x18,%esp
  800468:	52                   	push   %edx
  800469:	50                   	push   %eax
  80046a:	89 f2                	mov    %esi,%edx
  80046c:	89 f8                	mov    %edi,%eax
  80046e:	e8 9e ff ff ff       	call   800411 <printnum>
  800473:	83 c4 20             	add    $0x20,%esp
  800476:	eb 13                	jmp    80048b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	56                   	push   %esi
  80047c:	ff 75 18             	pushl  0x18(%ebp)
  80047f:	ff d7                	call   *%edi
  800481:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800484:	83 eb 01             	sub    $0x1,%ebx
  800487:	85 db                	test   %ebx,%ebx
  800489:	7f ed                	jg     800478 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	56                   	push   %esi
  80048f:	83 ec 04             	sub    $0x4,%esp
  800492:	ff 75 e4             	pushl  -0x1c(%ebp)
  800495:	ff 75 e0             	pushl  -0x20(%ebp)
  800498:	ff 75 dc             	pushl  -0x24(%ebp)
  80049b:	ff 75 d8             	pushl  -0x28(%ebp)
  80049e:	e8 4d 0a 00 00       	call   800ef0 <__umoddi3>
  8004a3:	83 c4 14             	add    $0x14,%esp
  8004a6:	0f be 80 7d 10 80 00 	movsbl 0x80107d(%eax),%eax
  8004ad:	50                   	push   %eax
  8004ae:	ff d7                	call   *%edi
}
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004b6:	5b                   	pop    %ebx
  8004b7:	5e                   	pop    %esi
  8004b8:	5f                   	pop    %edi
  8004b9:	5d                   	pop    %ebp
  8004ba:	c3                   	ret    
  8004bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004be:	eb c4                	jmp    800484 <printnum+0x73>

008004c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ca:	8b 10                	mov    (%eax),%edx
  8004cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8004cf:	73 0a                	jae    8004db <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004d4:	89 08                	mov    %ecx,(%eax)
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	88 02                	mov    %al,(%edx)
}
  8004db:	5d                   	pop    %ebp
  8004dc:	c3                   	ret    

008004dd <printfmt>:
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004e3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 10             	pushl  0x10(%ebp)
  8004ea:	ff 75 0c             	pushl  0xc(%ebp)
  8004ed:	ff 75 08             	pushl  0x8(%ebp)
  8004f0:	e8 05 00 00 00       	call   8004fa <vprintfmt>
}
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <vprintfmt>:
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	57                   	push   %edi
  8004fe:	56                   	push   %esi
  8004ff:	53                   	push   %ebx
  800500:	83 ec 2c             	sub    $0x2c,%esp
  800503:	8b 75 08             	mov    0x8(%ebp),%esi
  800506:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800509:	8b 7d 10             	mov    0x10(%ebp),%edi
  80050c:	e9 00 04 00 00       	jmp    800911 <vprintfmt+0x417>
		padc = ' ';
  800511:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800515:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80051c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800523:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80052a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80052f:	8d 47 01             	lea    0x1(%edi),%eax
  800532:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800535:	0f b6 17             	movzbl (%edi),%edx
  800538:	8d 42 dd             	lea    -0x23(%edx),%eax
  80053b:	3c 55                	cmp    $0x55,%al
  80053d:	0f 87 51 04 00 00    	ja     800994 <vprintfmt+0x49a>
  800543:	0f b6 c0             	movzbl %al,%eax
  800546:	ff 24 85 40 11 80 00 	jmp    *0x801140(,%eax,4)
  80054d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800550:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800554:	eb d9                	jmp    80052f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800556:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800559:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80055d:	eb d0                	jmp    80052f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80055f:	0f b6 d2             	movzbl %dl,%edx
  800562:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800565:	b8 00 00 00 00       	mov    $0x0,%eax
  80056a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80056d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800570:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800574:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800577:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80057a:	83 f9 09             	cmp    $0x9,%ecx
  80057d:	77 55                	ja     8005d4 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80057f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800582:	eb e9                	jmp    80056d <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8d 40 04             	lea    0x4(%eax),%eax
  800592:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800595:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800598:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80059c:	79 91                	jns    80052f <vprintfmt+0x35>
				width = precision, precision = -1;
  80059e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005ab:	eb 82                	jmp    80052f <vprintfmt+0x35>
  8005ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b0:	85 c0                	test   %eax,%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b7:	0f 49 d0             	cmovns %eax,%edx
  8005ba:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005c0:	e9 6a ff ff ff       	jmp    80052f <vprintfmt+0x35>
  8005c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005c8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005cf:	e9 5b ff ff ff       	jmp    80052f <vprintfmt+0x35>
  8005d4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005da:	eb bc                	jmp    800598 <vprintfmt+0x9e>
			lflag++;
  8005dc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005e2:	e9 48 ff ff ff       	jmp    80052f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8d 78 04             	lea    0x4(%eax),%edi
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	53                   	push   %ebx
  8005f1:	ff 30                	pushl  (%eax)
  8005f3:	ff d6                	call   *%esi
			break;
  8005f5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005f8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005fb:	e9 0e 03 00 00       	jmp    80090e <vprintfmt+0x414>
			err = va_arg(ap, int);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8d 78 04             	lea    0x4(%eax),%edi
  800606:	8b 00                	mov    (%eax),%eax
  800608:	99                   	cltd   
  800609:	31 d0                	xor    %edx,%eax
  80060b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80060d:	83 f8 08             	cmp    $0x8,%eax
  800610:	7f 23                	jg     800635 <vprintfmt+0x13b>
  800612:	8b 14 85 a0 12 80 00 	mov    0x8012a0(,%eax,4),%edx
  800619:	85 d2                	test   %edx,%edx
  80061b:	74 18                	je     800635 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80061d:	52                   	push   %edx
  80061e:	68 9e 10 80 00       	push   $0x80109e
  800623:	53                   	push   %ebx
  800624:	56                   	push   %esi
  800625:	e8 b3 fe ff ff       	call   8004dd <printfmt>
  80062a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80062d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800630:	e9 d9 02 00 00       	jmp    80090e <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800635:	50                   	push   %eax
  800636:	68 95 10 80 00       	push   $0x801095
  80063b:	53                   	push   %ebx
  80063c:	56                   	push   %esi
  80063d:	e8 9b fe ff ff       	call   8004dd <printfmt>
  800642:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800645:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800648:	e9 c1 02 00 00       	jmp    80090e <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	83 c0 04             	add    $0x4,%eax
  800653:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80065b:	85 ff                	test   %edi,%edi
  80065d:	b8 8e 10 80 00       	mov    $0x80108e,%eax
  800662:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800665:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800669:	0f 8e bd 00 00 00    	jle    80072c <vprintfmt+0x232>
  80066f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800673:	75 0e                	jne    800683 <vprintfmt+0x189>
  800675:	89 75 08             	mov    %esi,0x8(%ebp)
  800678:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80067b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80067e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800681:	eb 6d                	jmp    8006f0 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	ff 75 d0             	pushl  -0x30(%ebp)
  800689:	57                   	push   %edi
  80068a:	e8 ad 03 00 00       	call   800a3c <strnlen>
  80068f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800692:	29 c1                	sub    %eax,%ecx
  800694:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800697:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80069a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80069e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006a4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a6:	eb 0f                	jmp    8006b7 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	53                   	push   %ebx
  8006ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8006af:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b1:	83 ef 01             	sub    $0x1,%edi
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	85 ff                	test   %edi,%edi
  8006b9:	7f ed                	jg     8006a8 <vprintfmt+0x1ae>
  8006bb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006be:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006c1:	85 c9                	test   %ecx,%ecx
  8006c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c8:	0f 49 c1             	cmovns %ecx,%eax
  8006cb:	29 c1                	sub    %eax,%ecx
  8006cd:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006d3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006d6:	89 cb                	mov    %ecx,%ebx
  8006d8:	eb 16                	jmp    8006f0 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006da:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006de:	75 31                	jne    800711 <vprintfmt+0x217>
					putch(ch, putdat);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	50                   	push   %eax
  8006e7:	ff 55 08             	call   *0x8(%ebp)
  8006ea:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ed:	83 eb 01             	sub    $0x1,%ebx
  8006f0:	83 c7 01             	add    $0x1,%edi
  8006f3:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006f7:	0f be c2             	movsbl %dl,%eax
  8006fa:	85 c0                	test   %eax,%eax
  8006fc:	74 59                	je     800757 <vprintfmt+0x25d>
  8006fe:	85 f6                	test   %esi,%esi
  800700:	78 d8                	js     8006da <vprintfmt+0x1e0>
  800702:	83 ee 01             	sub    $0x1,%esi
  800705:	79 d3                	jns    8006da <vprintfmt+0x1e0>
  800707:	89 df                	mov    %ebx,%edi
  800709:	8b 75 08             	mov    0x8(%ebp),%esi
  80070c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80070f:	eb 37                	jmp    800748 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800711:	0f be d2             	movsbl %dl,%edx
  800714:	83 ea 20             	sub    $0x20,%edx
  800717:	83 fa 5e             	cmp    $0x5e,%edx
  80071a:	76 c4                	jbe    8006e0 <vprintfmt+0x1e6>
					putch('?', putdat);
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	ff 75 0c             	pushl  0xc(%ebp)
  800722:	6a 3f                	push   $0x3f
  800724:	ff 55 08             	call   *0x8(%ebp)
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	eb c1                	jmp    8006ed <vprintfmt+0x1f3>
  80072c:	89 75 08             	mov    %esi,0x8(%ebp)
  80072f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800732:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800735:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800738:	eb b6                	jmp    8006f0 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	53                   	push   %ebx
  80073e:	6a 20                	push   $0x20
  800740:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800742:	83 ef 01             	sub    $0x1,%edi
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	85 ff                	test   %edi,%edi
  80074a:	7f ee                	jg     80073a <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80074c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
  800752:	e9 b7 01 00 00       	jmp    80090e <vprintfmt+0x414>
  800757:	89 df                	mov    %ebx,%edi
  800759:	8b 75 08             	mov    0x8(%ebp),%esi
  80075c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80075f:	eb e7                	jmp    800748 <vprintfmt+0x24e>
	if (lflag >= 2)
  800761:	83 f9 01             	cmp    $0x1,%ecx
  800764:	7e 3f                	jle    8007a5 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 50 04             	mov    0x4(%eax),%edx
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800771:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 40 08             	lea    0x8(%eax),%eax
  80077a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80077d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800781:	79 5c                	jns    8007df <vprintfmt+0x2e5>
				putch('-', putdat);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	53                   	push   %ebx
  800787:	6a 2d                	push   $0x2d
  800789:	ff d6                	call   *%esi
				num = -(long long) num;
  80078b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80078e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800791:	f7 da                	neg    %edx
  800793:	83 d1 00             	adc    $0x0,%ecx
  800796:	f7 d9                	neg    %ecx
  800798:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80079b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a0:	e9 4f 01 00 00       	jmp    8008f4 <vprintfmt+0x3fa>
	else if (lflag)
  8007a5:	85 c9                	test   %ecx,%ecx
  8007a7:	75 1b                	jne    8007c4 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b1:	89 c1                	mov    %eax,%ecx
  8007b3:	c1 f9 1f             	sar    $0x1f,%ecx
  8007b6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c2:	eb b9                	jmp    80077d <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cc:	89 c1                	mov    %eax,%ecx
  8007ce:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	8d 40 04             	lea    0x4(%eax),%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dd:	eb 9e                	jmp    80077d <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007df:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007e2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ea:	e9 05 01 00 00       	jmp    8008f4 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007ef:	83 f9 01             	cmp    $0x1,%ecx
  8007f2:	7e 18                	jle    80080c <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8b 10                	mov    (%eax),%edx
  8007f9:	8b 48 04             	mov    0x4(%eax),%ecx
  8007fc:	8d 40 08             	lea    0x8(%eax),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800802:	b8 0a 00 00 00       	mov    $0xa,%eax
  800807:	e9 e8 00 00 00       	jmp    8008f4 <vprintfmt+0x3fa>
	else if (lflag)
  80080c:	85 c9                	test   %ecx,%ecx
  80080e:	75 1a                	jne    80082a <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	8b 10                	mov    (%eax),%edx
  800815:	b9 00 00 00 00       	mov    $0x0,%ecx
  80081a:	8d 40 04             	lea    0x4(%eax),%eax
  80081d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800820:	b8 0a 00 00 00       	mov    $0xa,%eax
  800825:	e9 ca 00 00 00       	jmp    8008f4 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80082a:	8b 45 14             	mov    0x14(%ebp),%eax
  80082d:	8b 10                	mov    (%eax),%edx
  80082f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800834:	8d 40 04             	lea    0x4(%eax),%eax
  800837:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80083a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083f:	e9 b0 00 00 00       	jmp    8008f4 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800844:	83 f9 01             	cmp    $0x1,%ecx
  800847:	7e 3c                	jle    800885 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	8b 50 04             	mov    0x4(%eax),%edx
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800854:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	8d 40 08             	lea    0x8(%eax),%eax
  80085d:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800860:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800864:	79 59                	jns    8008bf <vprintfmt+0x3c5>
                putch('-', putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	53                   	push   %ebx
  80086a:	6a 2d                	push   $0x2d
  80086c:	ff d6                	call   *%esi
                num = -(long long) num;
  80086e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800871:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800874:	f7 da                	neg    %edx
  800876:	83 d1 00             	adc    $0x0,%ecx
  800879:	f7 d9                	neg    %ecx
  80087b:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80087e:	b8 08 00 00 00       	mov    $0x8,%eax
  800883:	eb 6f                	jmp    8008f4 <vprintfmt+0x3fa>
	else if (lflag)
  800885:	85 c9                	test   %ecx,%ecx
  800887:	75 1b                	jne    8008a4 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800891:	89 c1                	mov    %eax,%ecx
  800893:	c1 f9 1f             	sar    $0x1f,%ecx
  800896:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	8d 40 04             	lea    0x4(%eax),%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a2:	eb bc                	jmp    800860 <vprintfmt+0x366>
		return va_arg(*ap, long);
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ac:	89 c1                	mov    %eax,%ecx
  8008ae:	c1 f9 1f             	sar    $0x1f,%ecx
  8008b1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8d 40 04             	lea    0x4(%eax),%eax
  8008ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bd:	eb a1                	jmp    800860 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8008bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008c2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8008c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8008ca:	eb 28                	jmp    8008f4 <vprintfmt+0x3fa>
			putch('0', putdat);
  8008cc:	83 ec 08             	sub    $0x8,%esp
  8008cf:	53                   	push   %ebx
  8008d0:	6a 30                	push   $0x30
  8008d2:	ff d6                	call   *%esi
			putch('x', putdat);
  8008d4:	83 c4 08             	add    $0x8,%esp
  8008d7:	53                   	push   %ebx
  8008d8:	6a 78                	push   $0x78
  8008da:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	8b 10                	mov    (%eax),%edx
  8008e1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008e6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008e9:	8d 40 04             	lea    0x4(%eax),%eax
  8008ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ef:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008f4:	83 ec 0c             	sub    $0xc,%esp
  8008f7:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008fb:	57                   	push   %edi
  8008fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8008ff:	50                   	push   %eax
  800900:	51                   	push   %ecx
  800901:	52                   	push   %edx
  800902:	89 da                	mov    %ebx,%edx
  800904:	89 f0                	mov    %esi,%eax
  800906:	e8 06 fb ff ff       	call   800411 <printnum>
			break;
  80090b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80090e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800911:	83 c7 01             	add    $0x1,%edi
  800914:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800918:	83 f8 25             	cmp    $0x25,%eax
  80091b:	0f 84 f0 fb ff ff    	je     800511 <vprintfmt+0x17>
			if (ch == '\0')
  800921:	85 c0                	test   %eax,%eax
  800923:	0f 84 8b 00 00 00    	je     8009b4 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	53                   	push   %ebx
  80092d:	50                   	push   %eax
  80092e:	ff d6                	call   *%esi
  800930:	83 c4 10             	add    $0x10,%esp
  800933:	eb dc                	jmp    800911 <vprintfmt+0x417>
	if (lflag >= 2)
  800935:	83 f9 01             	cmp    $0x1,%ecx
  800938:	7e 15                	jle    80094f <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8b 10                	mov    (%eax),%edx
  80093f:	8b 48 04             	mov    0x4(%eax),%ecx
  800942:	8d 40 08             	lea    0x8(%eax),%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800948:	b8 10 00 00 00       	mov    $0x10,%eax
  80094d:	eb a5                	jmp    8008f4 <vprintfmt+0x3fa>
	else if (lflag)
  80094f:	85 c9                	test   %ecx,%ecx
  800951:	75 17                	jne    80096a <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800953:	8b 45 14             	mov    0x14(%ebp),%eax
  800956:	8b 10                	mov    (%eax),%edx
  800958:	b9 00 00 00 00       	mov    $0x0,%ecx
  80095d:	8d 40 04             	lea    0x4(%eax),%eax
  800960:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800963:	b8 10 00 00 00       	mov    $0x10,%eax
  800968:	eb 8a                	jmp    8008f4 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	8b 10                	mov    (%eax),%edx
  80096f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800974:	8d 40 04             	lea    0x4(%eax),%eax
  800977:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80097a:	b8 10 00 00 00       	mov    $0x10,%eax
  80097f:	e9 70 ff ff ff       	jmp    8008f4 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	53                   	push   %ebx
  800988:	6a 25                	push   $0x25
  80098a:	ff d6                	call   *%esi
			break;
  80098c:	83 c4 10             	add    $0x10,%esp
  80098f:	e9 7a ff ff ff       	jmp    80090e <vprintfmt+0x414>
			putch('%', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	53                   	push   %ebx
  800998:	6a 25                	push   $0x25
  80099a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80099c:	83 c4 10             	add    $0x10,%esp
  80099f:	89 f8                	mov    %edi,%eax
  8009a1:	eb 03                	jmp    8009a6 <vprintfmt+0x4ac>
  8009a3:	83 e8 01             	sub    $0x1,%eax
  8009a6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009aa:	75 f7                	jne    8009a3 <vprintfmt+0x4a9>
  8009ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009af:	e9 5a ff ff ff       	jmp    80090e <vprintfmt+0x414>
}
  8009b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009b7:	5b                   	pop    %ebx
  8009b8:	5e                   	pop    %esi
  8009b9:	5f                   	pop    %edi
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	83 ec 18             	sub    $0x18,%esp
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009cb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009cf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009d9:	85 c0                	test   %eax,%eax
  8009db:	74 26                	je     800a03 <vsnprintf+0x47>
  8009dd:	85 d2                	test   %edx,%edx
  8009df:	7e 22                	jle    800a03 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009e1:	ff 75 14             	pushl  0x14(%ebp)
  8009e4:	ff 75 10             	pushl  0x10(%ebp)
  8009e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ea:	50                   	push   %eax
  8009eb:	68 c0 04 80 00       	push   $0x8004c0
  8009f0:	e8 05 fb ff ff       	call   8004fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
}
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    
		return -E_INVAL;
  800a03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a08:	eb f7                	jmp    800a01 <vsnprintf+0x45>

00800a0a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a10:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a13:	50                   	push   %eax
  800a14:	ff 75 10             	pushl  0x10(%ebp)
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	ff 75 08             	pushl  0x8(%ebp)
  800a1d:	e8 9a ff ff ff       	call   8009bc <vsnprintf>
	va_end(ap);

	return rc;
}
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2f:	eb 03                	jmp    800a34 <strlen+0x10>
		n++;
  800a31:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a34:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a38:	75 f7                	jne    800a31 <strlen+0xd>
	return n;
}
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    

00800a3c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a42:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a45:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4a:	eb 03                	jmp    800a4f <strnlen+0x13>
		n++;
  800a4c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a4f:	39 d0                	cmp    %edx,%eax
  800a51:	74 06                	je     800a59 <strnlen+0x1d>
  800a53:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a57:	75 f3                	jne    800a4c <strnlen+0x10>
	return n;
}
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	53                   	push   %ebx
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a65:	89 c2                	mov    %eax,%edx
  800a67:	83 c1 01             	add    $0x1,%ecx
  800a6a:	83 c2 01             	add    $0x1,%edx
  800a6d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a71:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a74:	84 db                	test   %bl,%bl
  800a76:	75 ef                	jne    800a67 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a78:	5b                   	pop    %ebx
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	53                   	push   %ebx
  800a7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a82:	53                   	push   %ebx
  800a83:	e8 9c ff ff ff       	call   800a24 <strlen>
  800a88:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	01 d8                	add    %ebx,%eax
  800a90:	50                   	push   %eax
  800a91:	e8 c5 ff ff ff       	call   800a5b <strcpy>
	return dst;
}
  800a96:	89 d8                	mov    %ebx,%eax
  800a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
  800aa2:	8b 75 08             	mov    0x8(%ebp),%esi
  800aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa8:	89 f3                	mov    %esi,%ebx
  800aaa:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aad:	89 f2                	mov    %esi,%edx
  800aaf:	eb 0f                	jmp    800ac0 <strncpy+0x23>
		*dst++ = *src;
  800ab1:	83 c2 01             	add    $0x1,%edx
  800ab4:	0f b6 01             	movzbl (%ecx),%eax
  800ab7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aba:	80 39 01             	cmpb   $0x1,(%ecx)
  800abd:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800ac0:	39 da                	cmp    %ebx,%edx
  800ac2:	75 ed                	jne    800ab1 <strncpy+0x14>
	}
	return ret;
}
  800ac4:	89 f0                	mov    %esi,%eax
  800ac6:	5b                   	pop    %ebx
  800ac7:	5e                   	pop    %esi
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	56                   	push   %esi
  800ace:	53                   	push   %ebx
  800acf:	8b 75 08             	mov    0x8(%ebp),%esi
  800ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ad8:	89 f0                	mov    %esi,%eax
  800ada:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ade:	85 c9                	test   %ecx,%ecx
  800ae0:	75 0b                	jne    800aed <strlcpy+0x23>
  800ae2:	eb 17                	jmp    800afb <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ae4:	83 c2 01             	add    $0x1,%edx
  800ae7:	83 c0 01             	add    $0x1,%eax
  800aea:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800aed:	39 d8                	cmp    %ebx,%eax
  800aef:	74 07                	je     800af8 <strlcpy+0x2e>
  800af1:	0f b6 0a             	movzbl (%edx),%ecx
  800af4:	84 c9                	test   %cl,%cl
  800af6:	75 ec                	jne    800ae4 <strlcpy+0x1a>
		*dst = '\0';
  800af8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afb:	29 f0                	sub    %esi,%eax
}
  800afd:	5b                   	pop    %ebx
  800afe:	5e                   	pop    %esi
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b07:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b0a:	eb 06                	jmp    800b12 <strcmp+0x11>
		p++, q++;
  800b0c:	83 c1 01             	add    $0x1,%ecx
  800b0f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b12:	0f b6 01             	movzbl (%ecx),%eax
  800b15:	84 c0                	test   %al,%al
  800b17:	74 04                	je     800b1d <strcmp+0x1c>
  800b19:	3a 02                	cmp    (%edx),%al
  800b1b:	74 ef                	je     800b0c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b1d:	0f b6 c0             	movzbl %al,%eax
  800b20:	0f b6 12             	movzbl (%edx),%edx
  800b23:	29 d0                	sub    %edx,%eax
}
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	53                   	push   %ebx
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b31:	89 c3                	mov    %eax,%ebx
  800b33:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b36:	eb 06                	jmp    800b3e <strncmp+0x17>
		n--, p++, q++;
  800b38:	83 c0 01             	add    $0x1,%eax
  800b3b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b3e:	39 d8                	cmp    %ebx,%eax
  800b40:	74 16                	je     800b58 <strncmp+0x31>
  800b42:	0f b6 08             	movzbl (%eax),%ecx
  800b45:	84 c9                	test   %cl,%cl
  800b47:	74 04                	je     800b4d <strncmp+0x26>
  800b49:	3a 0a                	cmp    (%edx),%cl
  800b4b:	74 eb                	je     800b38 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4d:	0f b6 00             	movzbl (%eax),%eax
  800b50:	0f b6 12             	movzbl (%edx),%edx
  800b53:	29 d0                	sub    %edx,%eax
}
  800b55:	5b                   	pop    %ebx
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    
		return 0;
  800b58:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5d:	eb f6                	jmp    800b55 <strncmp+0x2e>

00800b5f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b69:	0f b6 10             	movzbl (%eax),%edx
  800b6c:	84 d2                	test   %dl,%dl
  800b6e:	74 09                	je     800b79 <strchr+0x1a>
		if (*s == c)
  800b70:	38 ca                	cmp    %cl,%dl
  800b72:	74 0a                	je     800b7e <strchr+0x1f>
	for (; *s; s++)
  800b74:	83 c0 01             	add    $0x1,%eax
  800b77:	eb f0                	jmp    800b69 <strchr+0xa>
			return (char *) s;
	return 0;
  800b79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b8a:	eb 03                	jmp    800b8f <strfind+0xf>
  800b8c:	83 c0 01             	add    $0x1,%eax
  800b8f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b92:	38 ca                	cmp    %cl,%dl
  800b94:	74 04                	je     800b9a <strfind+0x1a>
  800b96:	84 d2                	test   %dl,%dl
  800b98:	75 f2                	jne    800b8c <strfind+0xc>
			break;
	return (char *) s;
}
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	57                   	push   %edi
  800ba0:	56                   	push   %esi
  800ba1:	53                   	push   %ebx
  800ba2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba8:	85 c9                	test   %ecx,%ecx
  800baa:	74 13                	je     800bbf <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bac:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bb2:	75 05                	jne    800bb9 <memset+0x1d>
  800bb4:	f6 c1 03             	test   $0x3,%cl
  800bb7:	74 0d                	je     800bc6 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	fc                   	cld    
  800bbd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bbf:	89 f8                	mov    %edi,%eax
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    
		c &= 0xFF;
  800bc6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bca:	89 d3                	mov    %edx,%ebx
  800bcc:	c1 e3 08             	shl    $0x8,%ebx
  800bcf:	89 d0                	mov    %edx,%eax
  800bd1:	c1 e0 18             	shl    $0x18,%eax
  800bd4:	89 d6                	mov    %edx,%esi
  800bd6:	c1 e6 10             	shl    $0x10,%esi
  800bd9:	09 f0                	or     %esi,%eax
  800bdb:	09 c2                	or     %eax,%edx
  800bdd:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bdf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800be2:	89 d0                	mov    %edx,%eax
  800be4:	fc                   	cld    
  800be5:	f3 ab                	rep stos %eax,%es:(%edi)
  800be7:	eb d6                	jmp    800bbf <memset+0x23>

00800be9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf7:	39 c6                	cmp    %eax,%esi
  800bf9:	73 35                	jae    800c30 <memmove+0x47>
  800bfb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bfe:	39 c2                	cmp    %eax,%edx
  800c00:	76 2e                	jbe    800c30 <memmove+0x47>
		s += n;
		d += n;
  800c02:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c05:	89 d6                	mov    %edx,%esi
  800c07:	09 fe                	or     %edi,%esi
  800c09:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c0f:	74 0c                	je     800c1d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c11:	83 ef 01             	sub    $0x1,%edi
  800c14:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c17:	fd                   	std    
  800c18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c1a:	fc                   	cld    
  800c1b:	eb 21                	jmp    800c3e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c1d:	f6 c1 03             	test   $0x3,%cl
  800c20:	75 ef                	jne    800c11 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c22:	83 ef 04             	sub    $0x4,%edi
  800c25:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c28:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c2b:	fd                   	std    
  800c2c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2e:	eb ea                	jmp    800c1a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c30:	89 f2                	mov    %esi,%edx
  800c32:	09 c2                	or     %eax,%edx
  800c34:	f6 c2 03             	test   $0x3,%dl
  800c37:	74 09                	je     800c42 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c39:	89 c7                	mov    %eax,%edi
  800c3b:	fc                   	cld    
  800c3c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c3e:	5e                   	pop    %esi
  800c3f:	5f                   	pop    %edi
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c42:	f6 c1 03             	test   $0x3,%cl
  800c45:	75 f2                	jne    800c39 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c47:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c4a:	89 c7                	mov    %eax,%edi
  800c4c:	fc                   	cld    
  800c4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c4f:	eb ed                	jmp    800c3e <memmove+0x55>

00800c51 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c54:	ff 75 10             	pushl  0x10(%ebp)
  800c57:	ff 75 0c             	pushl  0xc(%ebp)
  800c5a:	ff 75 08             	pushl  0x8(%ebp)
  800c5d:	e8 87 ff ff ff       	call   800be9 <memmove>
}
  800c62:	c9                   	leave  
  800c63:	c3                   	ret    

00800c64 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	89 c6                	mov    %eax,%esi
  800c71:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c74:	39 f0                	cmp    %esi,%eax
  800c76:	74 1c                	je     800c94 <memcmp+0x30>
		if (*s1 != *s2)
  800c78:	0f b6 08             	movzbl (%eax),%ecx
  800c7b:	0f b6 1a             	movzbl (%edx),%ebx
  800c7e:	38 d9                	cmp    %bl,%cl
  800c80:	75 08                	jne    800c8a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c82:	83 c0 01             	add    $0x1,%eax
  800c85:	83 c2 01             	add    $0x1,%edx
  800c88:	eb ea                	jmp    800c74 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c8a:	0f b6 c1             	movzbl %cl,%eax
  800c8d:	0f b6 db             	movzbl %bl,%ebx
  800c90:	29 d8                	sub    %ebx,%eax
  800c92:	eb 05                	jmp    800c99 <memcmp+0x35>
	}

	return 0;
  800c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ca6:	89 c2                	mov    %eax,%edx
  800ca8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cab:	39 d0                	cmp    %edx,%eax
  800cad:	73 09                	jae    800cb8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800caf:	38 08                	cmp    %cl,(%eax)
  800cb1:	74 05                	je     800cb8 <memfind+0x1b>
	for (; s < ends; s++)
  800cb3:	83 c0 01             	add    $0x1,%eax
  800cb6:	eb f3                	jmp    800cab <memfind+0xe>
			break;
	return (void *) s;
}
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
  800cc0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc6:	eb 03                	jmp    800ccb <strtol+0x11>
		s++;
  800cc8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ccb:	0f b6 01             	movzbl (%ecx),%eax
  800cce:	3c 20                	cmp    $0x20,%al
  800cd0:	74 f6                	je     800cc8 <strtol+0xe>
  800cd2:	3c 09                	cmp    $0x9,%al
  800cd4:	74 f2                	je     800cc8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cd6:	3c 2b                	cmp    $0x2b,%al
  800cd8:	74 2e                	je     800d08 <strtol+0x4e>
	int neg = 0;
  800cda:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cdf:	3c 2d                	cmp    $0x2d,%al
  800ce1:	74 2f                	je     800d12 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ce9:	75 05                	jne    800cf0 <strtol+0x36>
  800ceb:	80 39 30             	cmpb   $0x30,(%ecx)
  800cee:	74 2c                	je     800d1c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cf0:	85 db                	test   %ebx,%ebx
  800cf2:	75 0a                	jne    800cfe <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cf4:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cf9:	80 39 30             	cmpb   $0x30,(%ecx)
  800cfc:	74 28                	je     800d26 <strtol+0x6c>
		base = 10;
  800cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800d03:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d06:	eb 50                	jmp    800d58 <strtol+0x9e>
		s++;
  800d08:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d0b:	bf 00 00 00 00       	mov    $0x0,%edi
  800d10:	eb d1                	jmp    800ce3 <strtol+0x29>
		s++, neg = 1;
  800d12:	83 c1 01             	add    $0x1,%ecx
  800d15:	bf 01 00 00 00       	mov    $0x1,%edi
  800d1a:	eb c7                	jmp    800ce3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d1c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d20:	74 0e                	je     800d30 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d22:	85 db                	test   %ebx,%ebx
  800d24:	75 d8                	jne    800cfe <strtol+0x44>
		s++, base = 8;
  800d26:	83 c1 01             	add    $0x1,%ecx
  800d29:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d2e:	eb ce                	jmp    800cfe <strtol+0x44>
		s += 2, base = 16;
  800d30:	83 c1 02             	add    $0x2,%ecx
  800d33:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d38:	eb c4                	jmp    800cfe <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d3a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d3d:	89 f3                	mov    %esi,%ebx
  800d3f:	80 fb 19             	cmp    $0x19,%bl
  800d42:	77 29                	ja     800d6d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d44:	0f be d2             	movsbl %dl,%edx
  800d47:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d4a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d4d:	7d 30                	jge    800d7f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d4f:	83 c1 01             	add    $0x1,%ecx
  800d52:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d56:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d58:	0f b6 11             	movzbl (%ecx),%edx
  800d5b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d5e:	89 f3                	mov    %esi,%ebx
  800d60:	80 fb 09             	cmp    $0x9,%bl
  800d63:	77 d5                	ja     800d3a <strtol+0x80>
			dig = *s - '0';
  800d65:	0f be d2             	movsbl %dl,%edx
  800d68:	83 ea 30             	sub    $0x30,%edx
  800d6b:	eb dd                	jmp    800d4a <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d6d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d70:	89 f3                	mov    %esi,%ebx
  800d72:	80 fb 19             	cmp    $0x19,%bl
  800d75:	77 08                	ja     800d7f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d77:	0f be d2             	movsbl %dl,%edx
  800d7a:	83 ea 37             	sub    $0x37,%edx
  800d7d:	eb cb                	jmp    800d4a <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d83:	74 05                	je     800d8a <strtol+0xd0>
		*endptr = (char *) s;
  800d85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d88:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d8a:	89 c2                	mov    %eax,%edx
  800d8c:	f7 da                	neg    %edx
  800d8e:	85 ff                	test   %edi,%edi
  800d90:	0f 45 c2             	cmovne %edx,%eax
}
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    

00800d98 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800d9e:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800da5:	74 0a                	je     800db1 <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    
		panic("set_pgfault_handler not implemented");
  800db1:	83 ec 04             	sub    $0x4,%esp
  800db4:	68 c4 12 80 00       	push   $0x8012c4
  800db9:	6a 20                	push   $0x20
  800dbb:	68 e8 12 80 00       	push   $0x8012e8
  800dc0:	e8 5d f5 ff ff       	call   800322 <_panic>
  800dc5:	66 90                	xchg   %ax,%ax
  800dc7:	66 90                	xchg   %ax,%ax
  800dc9:	66 90                	xchg   %ax,%ax
  800dcb:	66 90                	xchg   %ax,%ax
  800dcd:	66 90                	xchg   %ax,%ax
  800dcf:	90                   	nop

00800dd0 <__udivdi3>:
  800dd0:	55                   	push   %ebp
  800dd1:	57                   	push   %edi
  800dd2:	56                   	push   %esi
  800dd3:	53                   	push   %ebx
  800dd4:	83 ec 1c             	sub    $0x1c,%esp
  800dd7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800ddb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800ddf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800de3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800de7:	85 d2                	test   %edx,%edx
  800de9:	75 35                	jne    800e20 <__udivdi3+0x50>
  800deb:	39 f3                	cmp    %esi,%ebx
  800ded:	0f 87 bd 00 00 00    	ja     800eb0 <__udivdi3+0xe0>
  800df3:	85 db                	test   %ebx,%ebx
  800df5:	89 d9                	mov    %ebx,%ecx
  800df7:	75 0b                	jne    800e04 <__udivdi3+0x34>
  800df9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dfe:	31 d2                	xor    %edx,%edx
  800e00:	f7 f3                	div    %ebx
  800e02:	89 c1                	mov    %eax,%ecx
  800e04:	31 d2                	xor    %edx,%edx
  800e06:	89 f0                	mov    %esi,%eax
  800e08:	f7 f1                	div    %ecx
  800e0a:	89 c6                	mov    %eax,%esi
  800e0c:	89 e8                	mov    %ebp,%eax
  800e0e:	89 f7                	mov    %esi,%edi
  800e10:	f7 f1                	div    %ecx
  800e12:	89 fa                	mov    %edi,%edx
  800e14:	83 c4 1c             	add    $0x1c,%esp
  800e17:	5b                   	pop    %ebx
  800e18:	5e                   	pop    %esi
  800e19:	5f                   	pop    %edi
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    
  800e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e20:	39 f2                	cmp    %esi,%edx
  800e22:	77 7c                	ja     800ea0 <__udivdi3+0xd0>
  800e24:	0f bd fa             	bsr    %edx,%edi
  800e27:	83 f7 1f             	xor    $0x1f,%edi
  800e2a:	0f 84 98 00 00 00    	je     800ec8 <__udivdi3+0xf8>
  800e30:	89 f9                	mov    %edi,%ecx
  800e32:	b8 20 00 00 00       	mov    $0x20,%eax
  800e37:	29 f8                	sub    %edi,%eax
  800e39:	d3 e2                	shl    %cl,%edx
  800e3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e3f:	89 c1                	mov    %eax,%ecx
  800e41:	89 da                	mov    %ebx,%edx
  800e43:	d3 ea                	shr    %cl,%edx
  800e45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e49:	09 d1                	or     %edx,%ecx
  800e4b:	89 f2                	mov    %esi,%edx
  800e4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e51:	89 f9                	mov    %edi,%ecx
  800e53:	d3 e3                	shl    %cl,%ebx
  800e55:	89 c1                	mov    %eax,%ecx
  800e57:	d3 ea                	shr    %cl,%edx
  800e59:	89 f9                	mov    %edi,%ecx
  800e5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e5f:	d3 e6                	shl    %cl,%esi
  800e61:	89 eb                	mov    %ebp,%ebx
  800e63:	89 c1                	mov    %eax,%ecx
  800e65:	d3 eb                	shr    %cl,%ebx
  800e67:	09 de                	or     %ebx,%esi
  800e69:	89 f0                	mov    %esi,%eax
  800e6b:	f7 74 24 08          	divl   0x8(%esp)
  800e6f:	89 d6                	mov    %edx,%esi
  800e71:	89 c3                	mov    %eax,%ebx
  800e73:	f7 64 24 0c          	mull   0xc(%esp)
  800e77:	39 d6                	cmp    %edx,%esi
  800e79:	72 0c                	jb     800e87 <__udivdi3+0xb7>
  800e7b:	89 f9                	mov    %edi,%ecx
  800e7d:	d3 e5                	shl    %cl,%ebp
  800e7f:	39 c5                	cmp    %eax,%ebp
  800e81:	73 5d                	jae    800ee0 <__udivdi3+0x110>
  800e83:	39 d6                	cmp    %edx,%esi
  800e85:	75 59                	jne    800ee0 <__udivdi3+0x110>
  800e87:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e8a:	31 ff                	xor    %edi,%edi
  800e8c:	89 fa                	mov    %edi,%edx
  800e8e:	83 c4 1c             	add    $0x1c,%esp
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    
  800e96:	8d 76 00             	lea    0x0(%esi),%esi
  800e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800ea0:	31 ff                	xor    %edi,%edi
  800ea2:	31 c0                	xor    %eax,%eax
  800ea4:	89 fa                	mov    %edi,%edx
  800ea6:	83 c4 1c             	add    $0x1c,%esp
  800ea9:	5b                   	pop    %ebx
  800eaa:	5e                   	pop    %esi
  800eab:	5f                   	pop    %edi
  800eac:	5d                   	pop    %ebp
  800ead:	c3                   	ret    
  800eae:	66 90                	xchg   %ax,%ax
  800eb0:	31 ff                	xor    %edi,%edi
  800eb2:	89 e8                	mov    %ebp,%eax
  800eb4:	89 f2                	mov    %esi,%edx
  800eb6:	f7 f3                	div    %ebx
  800eb8:	89 fa                	mov    %edi,%edx
  800eba:	83 c4 1c             	add    $0x1c,%esp
  800ebd:	5b                   	pop    %ebx
  800ebe:	5e                   	pop    %esi
  800ebf:	5f                   	pop    %edi
  800ec0:	5d                   	pop    %ebp
  800ec1:	c3                   	ret    
  800ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ec8:	39 f2                	cmp    %esi,%edx
  800eca:	72 06                	jb     800ed2 <__udivdi3+0x102>
  800ecc:	31 c0                	xor    %eax,%eax
  800ece:	39 eb                	cmp    %ebp,%ebx
  800ed0:	77 d2                	ja     800ea4 <__udivdi3+0xd4>
  800ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ed7:	eb cb                	jmp    800ea4 <__udivdi3+0xd4>
  800ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ee0:	89 d8                	mov    %ebx,%eax
  800ee2:	31 ff                	xor    %edi,%edi
  800ee4:	eb be                	jmp    800ea4 <__udivdi3+0xd4>
  800ee6:	66 90                	xchg   %ax,%ax
  800ee8:	66 90                	xchg   %ax,%ax
  800eea:	66 90                	xchg   %ax,%ax
  800eec:	66 90                	xchg   %ax,%ax
  800eee:	66 90                	xchg   %ax,%ax

00800ef0 <__umoddi3>:
  800ef0:	55                   	push   %ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	53                   	push   %ebx
  800ef4:	83 ec 1c             	sub    $0x1c,%esp
  800ef7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800efb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800eff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f07:	85 ed                	test   %ebp,%ebp
  800f09:	89 f0                	mov    %esi,%eax
  800f0b:	89 da                	mov    %ebx,%edx
  800f0d:	75 19                	jne    800f28 <__umoddi3+0x38>
  800f0f:	39 df                	cmp    %ebx,%edi
  800f11:	0f 86 b1 00 00 00    	jbe    800fc8 <__umoddi3+0xd8>
  800f17:	f7 f7                	div    %edi
  800f19:	89 d0                	mov    %edx,%eax
  800f1b:	31 d2                	xor    %edx,%edx
  800f1d:	83 c4 1c             	add    $0x1c,%esp
  800f20:	5b                   	pop    %ebx
  800f21:	5e                   	pop    %esi
  800f22:	5f                   	pop    %edi
  800f23:	5d                   	pop    %ebp
  800f24:	c3                   	ret    
  800f25:	8d 76 00             	lea    0x0(%esi),%esi
  800f28:	39 dd                	cmp    %ebx,%ebp
  800f2a:	77 f1                	ja     800f1d <__umoddi3+0x2d>
  800f2c:	0f bd cd             	bsr    %ebp,%ecx
  800f2f:	83 f1 1f             	xor    $0x1f,%ecx
  800f32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f36:	0f 84 b4 00 00 00    	je     800ff0 <__umoddi3+0x100>
  800f3c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f41:	89 c2                	mov    %eax,%edx
  800f43:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f47:	29 c2                	sub    %eax,%edx
  800f49:	89 c1                	mov    %eax,%ecx
  800f4b:	89 f8                	mov    %edi,%eax
  800f4d:	d3 e5                	shl    %cl,%ebp
  800f4f:	89 d1                	mov    %edx,%ecx
  800f51:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f55:	d3 e8                	shr    %cl,%eax
  800f57:	09 c5                	or     %eax,%ebp
  800f59:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f5d:	89 c1                	mov    %eax,%ecx
  800f5f:	d3 e7                	shl    %cl,%edi
  800f61:	89 d1                	mov    %edx,%ecx
  800f63:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f67:	89 df                	mov    %ebx,%edi
  800f69:	d3 ef                	shr    %cl,%edi
  800f6b:	89 c1                	mov    %eax,%ecx
  800f6d:	89 f0                	mov    %esi,%eax
  800f6f:	d3 e3                	shl    %cl,%ebx
  800f71:	89 d1                	mov    %edx,%ecx
  800f73:	89 fa                	mov    %edi,%edx
  800f75:	d3 e8                	shr    %cl,%eax
  800f77:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f7c:	09 d8                	or     %ebx,%eax
  800f7e:	f7 f5                	div    %ebp
  800f80:	d3 e6                	shl    %cl,%esi
  800f82:	89 d1                	mov    %edx,%ecx
  800f84:	f7 64 24 08          	mull   0x8(%esp)
  800f88:	39 d1                	cmp    %edx,%ecx
  800f8a:	89 c3                	mov    %eax,%ebx
  800f8c:	89 d7                	mov    %edx,%edi
  800f8e:	72 06                	jb     800f96 <__umoddi3+0xa6>
  800f90:	75 0e                	jne    800fa0 <__umoddi3+0xb0>
  800f92:	39 c6                	cmp    %eax,%esi
  800f94:	73 0a                	jae    800fa0 <__umoddi3+0xb0>
  800f96:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f9a:	19 ea                	sbb    %ebp,%edx
  800f9c:	89 d7                	mov    %edx,%edi
  800f9e:	89 c3                	mov    %eax,%ebx
  800fa0:	89 ca                	mov    %ecx,%edx
  800fa2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800fa7:	29 de                	sub    %ebx,%esi
  800fa9:	19 fa                	sbb    %edi,%edx
  800fab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800faf:	89 d0                	mov    %edx,%eax
  800fb1:	d3 e0                	shl    %cl,%eax
  800fb3:	89 d9                	mov    %ebx,%ecx
  800fb5:	d3 ee                	shr    %cl,%esi
  800fb7:	d3 ea                	shr    %cl,%edx
  800fb9:	09 f0                	or     %esi,%eax
  800fbb:	83 c4 1c             	add    $0x1c,%esp
  800fbe:	5b                   	pop    %ebx
  800fbf:	5e                   	pop    %esi
  800fc0:	5f                   	pop    %edi
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    
  800fc3:	90                   	nop
  800fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800fc8:	85 ff                	test   %edi,%edi
  800fca:	89 f9                	mov    %edi,%ecx
  800fcc:	75 0b                	jne    800fd9 <__umoddi3+0xe9>
  800fce:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd3:	31 d2                	xor    %edx,%edx
  800fd5:	f7 f7                	div    %edi
  800fd7:	89 c1                	mov    %eax,%ecx
  800fd9:	89 d8                	mov    %ebx,%eax
  800fdb:	31 d2                	xor    %edx,%edx
  800fdd:	f7 f1                	div    %ecx
  800fdf:	89 f0                	mov    %esi,%eax
  800fe1:	f7 f1                	div    %ecx
  800fe3:	e9 31 ff ff ff       	jmp    800f19 <__umoddi3+0x29>
  800fe8:	90                   	nop
  800fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ff0:	39 dd                	cmp    %ebx,%ebp
  800ff2:	72 08                	jb     800ffc <__umoddi3+0x10c>
  800ff4:	39 f7                	cmp    %esi,%edi
  800ff6:	0f 87 21 ff ff ff    	ja     800f1d <__umoddi3+0x2d>
  800ffc:	89 da                	mov    %ebx,%edx
  800ffe:	89 f0                	mov    %esi,%eax
  801000:	29 f8                	sub    %edi,%eax
  801002:	19 ea                	sbb    %ebp,%edx
  801004:	e9 14 ff ff ff       	jmp    800f1d <__umoddi3+0x2d>
