
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
  800039:	68 07 03 80 00       	push   $0x800307
  80003e:	6a 00                	push   $0x0
  800040:	e8 1c 02 00 00       	call   800261 <sys_env_set_pgfault_upcall>
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
  800057:	83 ec 08             	sub    $0x8,%esp
  80005a:	8b 45 08             	mov    0x8(%ebp),%eax
  80005d:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800060:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  800067:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006a:	85 c0                	test   %eax,%eax
  80006c:	7e 08                	jle    800076 <libmain+0x22>
		binaryname = argv[0];
  80006e:	8b 0a                	mov    (%edx),%ecx
  800070:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  800076:	83 ec 08             	sub    $0x8,%esp
  800079:	52                   	push   %edx
  80007a:	50                   	push   %eax
  80007b:	e8 b3 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800080:	e8 05 00 00 00       	call   80008a <exit>
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	c9                   	leave  
  800089:	c3                   	ret    

0080008a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008a:	55                   	push   %ebp
  80008b:	89 e5                	mov    %esp,%ebp
  80008d:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800090:	6a 00                	push   $0x0
  800092:	e8 42 00 00 00       	call   8000d9 <sys_env_destroy>
}
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	c9                   	leave  
  80009b:	c3                   	ret    

0080009c <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80009c:	55                   	push   %ebp
  80009d:	89 e5                	mov    %esp,%ebp
  80009f:	57                   	push   %edi
  8000a0:	56                   	push   %esi
  8000a1:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ad:	89 c3                	mov    %eax,%ebx
  8000af:	89 c7                	mov    %eax,%edi
  8000b1:	89 c6                	mov    %eax,%esi
  8000b3:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000b5:	5b                   	pop    %ebx
  8000b6:	5e                   	pop    %esi
  8000b7:	5f                   	pop    %edi
  8000b8:	5d                   	pop    %ebp
  8000b9:	c3                   	ret    

008000ba <sys_cgetc>:

int
sys_cgetc(void) {
  8000ba:	55                   	push   %ebp
  8000bb:	89 e5                	mov    %esp,%ebp
  8000bd:	57                   	push   %edi
  8000be:	56                   	push   %esi
  8000bf:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8000ca:	89 d1                	mov    %edx,%ecx
  8000cc:	89 d3                	mov    %edx,%ebx
  8000ce:	89 d7                	mov    %edx,%edi
  8000d0:	89 d6                	mov    %edx,%esi
  8000d2:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d4:	5b                   	pop    %ebx
  8000d5:	5e                   	pop    %esi
  8000d6:	5f                   	pop    %edi
  8000d7:	5d                   	pop    %ebp
  8000d8:	c3                   	ret    

008000d9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000d9:	55                   	push   %ebp
  8000da:	89 e5                	mov    %esp,%ebp
  8000dc:	57                   	push   %edi
  8000dd:	56                   	push   %esi
  8000de:	53                   	push   %ebx
  8000df:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ea:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ef:	89 cb                	mov    %ecx,%ebx
  8000f1:	89 cf                	mov    %ecx,%edi
  8000f3:	89 ce                	mov    %ecx,%esi
  8000f5:	cd 30                	int    $0x30
    if (check && ret > 0)
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	7f 08                	jg     800103 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fe:	5b                   	pop    %ebx
  8000ff:	5e                   	pop    %esi
  800100:	5f                   	pop    %edi
  800101:	5d                   	pop    %ebp
  800102:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	50                   	push   %eax
  800107:	6a 03                	push   $0x3
  800109:	68 0a 10 80 00       	push   $0x80100a
  80010e:	6a 24                	push   $0x24
  800110:	68 27 10 80 00       	push   $0x801027
  800115:	e8 f8 01 00 00       	call   800312 <_panic>

0080011a <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80011a:	55                   	push   %ebp
  80011b:	89 e5                	mov    %esp,%ebp
  80011d:	57                   	push   %edi
  80011e:	56                   	push   %esi
  80011f:	53                   	push   %ebx
    asm volatile("int %1\n"
  800120:	ba 00 00 00 00       	mov    $0x0,%edx
  800125:	b8 02 00 00 00       	mov    $0x2,%eax
  80012a:	89 d1                	mov    %edx,%ecx
  80012c:	89 d3                	mov    %edx,%ebx
  80012e:	89 d7                	mov    %edx,%edi
  800130:	89 d6                	mov    %edx,%esi
  800132:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800134:	5b                   	pop    %ebx
  800135:	5e                   	pop    %esi
  800136:	5f                   	pop    %edi
  800137:	5d                   	pop    %ebp
  800138:	c3                   	ret    

00800139 <sys_yield>:

void
sys_yield(void)
{
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	57                   	push   %edi
  80013d:	56                   	push   %esi
  80013e:	53                   	push   %ebx
    asm volatile("int %1\n"
  80013f:	ba 00 00 00 00       	mov    $0x0,%edx
  800144:	b8 0a 00 00 00       	mov    $0xa,%eax
  800149:	89 d1                	mov    %edx,%ecx
  80014b:	89 d3                	mov    %edx,%ebx
  80014d:	89 d7                	mov    %edx,%edi
  80014f:	89 d6                	mov    %edx,%esi
  800151:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5f                   	pop    %edi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    

00800158 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	57                   	push   %edi
  80015c:	56                   	push   %esi
  80015d:	53                   	push   %ebx
  80015e:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800161:	be 00 00 00 00       	mov    $0x0,%esi
  800166:	8b 55 08             	mov    0x8(%ebp),%edx
  800169:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016c:	b8 04 00 00 00       	mov    $0x4,%eax
  800171:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800174:	89 f7                	mov    %esi,%edi
  800176:	cd 30                	int    $0x30
    if (check && ret > 0)
  800178:	85 c0                	test   %eax,%eax
  80017a:	7f 08                	jg     800184 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017f:	5b                   	pop    %ebx
  800180:	5e                   	pop    %esi
  800181:	5f                   	pop    %edi
  800182:	5d                   	pop    %ebp
  800183:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800184:	83 ec 0c             	sub    $0xc,%esp
  800187:	50                   	push   %eax
  800188:	6a 04                	push   $0x4
  80018a:	68 0a 10 80 00       	push   $0x80100a
  80018f:	6a 24                	push   $0x24
  800191:	68 27 10 80 00       	push   $0x801027
  800196:	e8 77 01 00 00       	call   800312 <_panic>

0080019b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	57                   	push   %edi
  80019f:	56                   	push   %esi
  8001a0:	53                   	push   %ebx
  8001a1:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001aa:	b8 05 00 00 00       	mov    $0x5,%eax
  8001af:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b8:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001ba:	85 c0                	test   %eax,%eax
  8001bc:	7f 08                	jg     8001c6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c1:	5b                   	pop    %ebx
  8001c2:	5e                   	pop    %esi
  8001c3:	5f                   	pop    %edi
  8001c4:	5d                   	pop    %ebp
  8001c5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	50                   	push   %eax
  8001ca:	6a 05                	push   $0x5
  8001cc:	68 0a 10 80 00       	push   $0x80100a
  8001d1:	6a 24                	push   $0x24
  8001d3:	68 27 10 80 00       	push   $0x801027
  8001d8:	e8 35 01 00 00       	call   800312 <_panic>

008001dd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	57                   	push   %edi
  8001e1:	56                   	push   %esi
  8001e2:	53                   	push   %ebx
  8001e3:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f1:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f6:	89 df                	mov    %ebx,%edi
  8001f8:	89 de                	mov    %ebx,%esi
  8001fa:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001fc:	85 c0                	test   %eax,%eax
  8001fe:	7f 08                	jg     800208 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800200:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800203:	5b                   	pop    %ebx
  800204:	5e                   	pop    %esi
  800205:	5f                   	pop    %edi
  800206:	5d                   	pop    %ebp
  800207:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	50                   	push   %eax
  80020c:	6a 06                	push   $0x6
  80020e:	68 0a 10 80 00       	push   $0x80100a
  800213:	6a 24                	push   $0x24
  800215:	68 27 10 80 00       	push   $0x801027
  80021a:	e8 f3 00 00 00       	call   800312 <_panic>

0080021f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80021f:	55                   	push   %ebp
  800220:	89 e5                	mov    %esp,%ebp
  800222:	57                   	push   %edi
  800223:	56                   	push   %esi
  800224:	53                   	push   %ebx
  800225:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800228:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022d:	8b 55 08             	mov    0x8(%ebp),%edx
  800230:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800233:	b8 08 00 00 00       	mov    $0x8,%eax
  800238:	89 df                	mov    %ebx,%edi
  80023a:	89 de                	mov    %ebx,%esi
  80023c:	cd 30                	int    $0x30
    if (check && ret > 0)
  80023e:	85 c0                	test   %eax,%eax
  800240:	7f 08                	jg     80024a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800242:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800245:	5b                   	pop    %ebx
  800246:	5e                   	pop    %esi
  800247:	5f                   	pop    %edi
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	50                   	push   %eax
  80024e:	6a 08                	push   $0x8
  800250:	68 0a 10 80 00       	push   $0x80100a
  800255:	6a 24                	push   $0x24
  800257:	68 27 10 80 00       	push   $0x801027
  80025c:	e8 b1 00 00 00       	call   800312 <_panic>

00800261 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	57                   	push   %edi
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
  800267:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80026a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026f:	8b 55 08             	mov    0x8(%ebp),%edx
  800272:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800275:	b8 09 00 00 00       	mov    $0x9,%eax
  80027a:	89 df                	mov    %ebx,%edi
  80027c:	89 de                	mov    %ebx,%esi
  80027e:	cd 30                	int    $0x30
    if (check && ret > 0)
  800280:	85 c0                	test   %eax,%eax
  800282:	7f 08                	jg     80028c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800284:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800287:	5b                   	pop    %ebx
  800288:	5e                   	pop    %esi
  800289:	5f                   	pop    %edi
  80028a:	5d                   	pop    %ebp
  80028b:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	6a 09                	push   $0x9
  800292:	68 0a 10 80 00       	push   $0x80100a
  800297:	6a 24                	push   $0x24
  800299:	68 27 10 80 00       	push   $0x801027
  80029e:	e8 6f 00 00 00       	call   800312 <_panic>

008002a3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	57                   	push   %edi
  8002a7:	56                   	push   %esi
  8002a8:	53                   	push   %ebx
    asm volatile("int %1\n"
  8002a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002af:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002b4:	be 00 00 00 00       	mov    $0x0,%esi
  8002b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002bc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002bf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002c1:	5b                   	pop    %ebx
  8002c2:	5e                   	pop    %esi
  8002c3:	5f                   	pop    %edi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	57                   	push   %edi
  8002ca:	56                   	push   %esi
  8002cb:	53                   	push   %ebx
  8002cc:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002dc:	89 cb                	mov    %ecx,%ebx
  8002de:	89 cf                	mov    %ecx,%edi
  8002e0:	89 ce                	mov    %ecx,%esi
  8002e2:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002e4:	85 c0                	test   %eax,%eax
  8002e6:	7f 08                	jg     8002f0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002eb:	5b                   	pop    %ebx
  8002ec:	5e                   	pop    %esi
  8002ed:	5f                   	pop    %edi
  8002ee:	5d                   	pop    %ebp
  8002ef:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8002f0:	83 ec 0c             	sub    $0xc,%esp
  8002f3:	50                   	push   %eax
  8002f4:	6a 0c                	push   $0xc
  8002f6:	68 0a 10 80 00       	push   $0x80100a
  8002fb:	6a 24                	push   $0x24
  8002fd:	68 27 10 80 00       	push   $0x801027
  800302:	e8 0b 00 00 00       	call   800312 <_panic>

00800307 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800307:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800308:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  80030d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80030f:	83 c4 04             	add    $0x4,%esp

00800312 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	56                   	push   %esi
  800316:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800317:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80031a:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800320:	e8 f5 fd ff ff       	call   80011a <sys_getenvid>
  800325:	83 ec 0c             	sub    $0xc,%esp
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	ff 75 08             	pushl  0x8(%ebp)
  80032e:	56                   	push   %esi
  80032f:	50                   	push   %eax
  800330:	68 38 10 80 00       	push   $0x801038
  800335:	e8 b3 00 00 00       	call   8003ed <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80033a:	83 c4 18             	add    $0x18,%esp
  80033d:	53                   	push   %ebx
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	e8 56 00 00 00       	call   80039c <vcprintf>
	cprintf("\n");
  800346:	c7 04 24 5b 10 80 00 	movl   $0x80105b,(%esp)
  80034d:	e8 9b 00 00 00       	call   8003ed <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800355:	cc                   	int3   
  800356:	eb fd                	jmp    800355 <_panic+0x43>

00800358 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800358:	55                   	push   %ebp
  800359:	89 e5                	mov    %esp,%ebp
  80035b:	53                   	push   %ebx
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800362:	8b 13                	mov    (%ebx),%edx
  800364:	8d 42 01             	lea    0x1(%edx),%eax
  800367:	89 03                	mov    %eax,(%ebx)
  800369:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80036c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800370:	3d ff 00 00 00       	cmp    $0xff,%eax
  800375:	74 09                	je     800380 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800377:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80037b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037e:	c9                   	leave  
  80037f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800380:	83 ec 08             	sub    $0x8,%esp
  800383:	68 ff 00 00 00       	push   $0xff
  800388:	8d 43 08             	lea    0x8(%ebx),%eax
  80038b:	50                   	push   %eax
  80038c:	e8 0b fd ff ff       	call   80009c <sys_cputs>
		b->idx = 0;
  800391:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	eb db                	jmp    800377 <putch+0x1f>

0080039c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003a5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ac:	00 00 00 
	b.cnt = 0;
  8003af:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003b9:	ff 75 0c             	pushl  0xc(%ebp)
  8003bc:	ff 75 08             	pushl  0x8(%ebp)
  8003bf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c5:	50                   	push   %eax
  8003c6:	68 58 03 80 00       	push   $0x800358
  8003cb:	e8 1a 01 00 00       	call   8004ea <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003d0:	83 c4 08             	add    $0x8,%esp
  8003d3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003d9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003df:	50                   	push   %eax
  8003e0:	e8 b7 fc ff ff       	call   80009c <sys_cputs>

	return b.cnt;
}
  8003e5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003eb:	c9                   	leave  
  8003ec:	c3                   	ret    

008003ed <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
  8003f0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003f3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003f6:	50                   	push   %eax
  8003f7:	ff 75 08             	pushl  0x8(%ebp)
  8003fa:	e8 9d ff ff ff       	call   80039c <vcprintf>
	va_end(ap);

	return cnt;
}
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    

00800401 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	57                   	push   %edi
  800405:	56                   	push   %esi
  800406:	53                   	push   %ebx
  800407:	83 ec 1c             	sub    $0x1c,%esp
  80040a:	89 c7                	mov    %eax,%edi
  80040c:	89 d6                	mov    %edx,%esi
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	8b 55 0c             	mov    0xc(%ebp),%edx
  800414:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800417:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80041a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80041d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800422:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800425:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800428:	39 d3                	cmp    %edx,%ebx
  80042a:	72 05                	jb     800431 <printnum+0x30>
  80042c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80042f:	77 7a                	ja     8004ab <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 18             	pushl  0x18(%ebp)
  800437:	8b 45 14             	mov    0x14(%ebp),%eax
  80043a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80043d:	53                   	push   %ebx
  80043e:	ff 75 10             	pushl  0x10(%ebp)
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	ff 75 e4             	pushl  -0x1c(%ebp)
  800447:	ff 75 e0             	pushl  -0x20(%ebp)
  80044a:	ff 75 dc             	pushl  -0x24(%ebp)
  80044d:	ff 75 d8             	pushl  -0x28(%ebp)
  800450:	e8 6b 09 00 00       	call   800dc0 <__udivdi3>
  800455:	83 c4 18             	add    $0x18,%esp
  800458:	52                   	push   %edx
  800459:	50                   	push   %eax
  80045a:	89 f2                	mov    %esi,%edx
  80045c:	89 f8                	mov    %edi,%eax
  80045e:	e8 9e ff ff ff       	call   800401 <printnum>
  800463:	83 c4 20             	add    $0x20,%esp
  800466:	eb 13                	jmp    80047b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	56                   	push   %esi
  80046c:	ff 75 18             	pushl  0x18(%ebp)
  80046f:	ff d7                	call   *%edi
  800471:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800474:	83 eb 01             	sub    $0x1,%ebx
  800477:	85 db                	test   %ebx,%ebx
  800479:	7f ed                	jg     800468 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	56                   	push   %esi
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	ff 75 e4             	pushl  -0x1c(%ebp)
  800485:	ff 75 e0             	pushl  -0x20(%ebp)
  800488:	ff 75 dc             	pushl  -0x24(%ebp)
  80048b:	ff 75 d8             	pushl  -0x28(%ebp)
  80048e:	e8 4d 0a 00 00       	call   800ee0 <__umoddi3>
  800493:	83 c4 14             	add    $0x14,%esp
  800496:	0f be 80 5d 10 80 00 	movsbl 0x80105d(%eax),%eax
  80049d:	50                   	push   %eax
  80049e:	ff d7                	call   *%edi
}
  8004a0:	83 c4 10             	add    $0x10,%esp
  8004a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004a6:	5b                   	pop    %ebx
  8004a7:	5e                   	pop    %esi
  8004a8:	5f                   	pop    %edi
  8004a9:	5d                   	pop    %ebp
  8004aa:	c3                   	ret    
  8004ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004ae:	eb c4                	jmp    800474 <printnum+0x73>

008004b0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004b6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ba:	8b 10                	mov    (%eax),%edx
  8004bc:	3b 50 04             	cmp    0x4(%eax),%edx
  8004bf:	73 0a                	jae    8004cb <sprintputch+0x1b>
		*b->buf++ = ch;
  8004c1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004c4:	89 08                	mov    %ecx,(%eax)
  8004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c9:	88 02                	mov    %al,(%edx)
}
  8004cb:	5d                   	pop    %ebp
  8004cc:	c3                   	ret    

008004cd <printfmt>:
{
  8004cd:	55                   	push   %ebp
  8004ce:	89 e5                	mov    %esp,%ebp
  8004d0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004d3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004d6:	50                   	push   %eax
  8004d7:	ff 75 10             	pushl  0x10(%ebp)
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	e8 05 00 00 00       	call   8004ea <vprintfmt>
}
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	c9                   	leave  
  8004e9:	c3                   	ret    

008004ea <vprintfmt>:
{
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	57                   	push   %edi
  8004ee:	56                   	push   %esi
  8004ef:	53                   	push   %ebx
  8004f0:	83 ec 2c             	sub    $0x2c,%esp
  8004f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004f9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004fc:	e9 00 04 00 00       	jmp    800901 <vprintfmt+0x417>
		padc = ' ';
  800501:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800505:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80050c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800513:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80051a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80051f:	8d 47 01             	lea    0x1(%edi),%eax
  800522:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800525:	0f b6 17             	movzbl (%edi),%edx
  800528:	8d 42 dd             	lea    -0x23(%edx),%eax
  80052b:	3c 55                	cmp    $0x55,%al
  80052d:	0f 87 51 04 00 00    	ja     800984 <vprintfmt+0x49a>
  800533:	0f b6 c0             	movzbl %al,%eax
  800536:	ff 24 85 20 11 80 00 	jmp    *0x801120(,%eax,4)
  80053d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800540:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800544:	eb d9                	jmp    80051f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800546:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800549:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80054d:	eb d0                	jmp    80051f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80054f:	0f b6 d2             	movzbl %dl,%edx
  800552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800555:	b8 00 00 00 00       	mov    $0x0,%eax
  80055a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80055d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800560:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800564:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800567:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80056a:	83 f9 09             	cmp    $0x9,%ecx
  80056d:	77 55                	ja     8005c4 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80056f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800572:	eb e9                	jmp    80055d <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8b 00                	mov    (%eax),%eax
  800579:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800585:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800588:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80058c:	79 91                	jns    80051f <vprintfmt+0x35>
				width = precision, precision = -1;
  80058e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800591:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800594:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80059b:	eb 82                	jmp    80051f <vprintfmt+0x35>
  80059d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a0:	85 c0                	test   %eax,%eax
  8005a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a7:	0f 49 d0             	cmovns %eax,%edx
  8005aa:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005b0:	e9 6a ff ff ff       	jmp    80051f <vprintfmt+0x35>
  8005b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005b8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005bf:	e9 5b ff ff ff       	jmp    80051f <vprintfmt+0x35>
  8005c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ca:	eb bc                	jmp    800588 <vprintfmt+0x9e>
			lflag++;
  8005cc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005d2:	e9 48 ff ff ff       	jmp    80051f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 78 04             	lea    0x4(%eax),%edi
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	53                   	push   %ebx
  8005e1:	ff 30                	pushl  (%eax)
  8005e3:	ff d6                	call   *%esi
			break;
  8005e5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005e8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005eb:	e9 0e 03 00 00       	jmp    8008fe <vprintfmt+0x414>
			err = va_arg(ap, int);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8d 78 04             	lea    0x4(%eax),%edi
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	99                   	cltd   
  8005f9:	31 d0                	xor    %edx,%eax
  8005fb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005fd:	83 f8 08             	cmp    $0x8,%eax
  800600:	7f 23                	jg     800625 <vprintfmt+0x13b>
  800602:	8b 14 85 80 12 80 00 	mov    0x801280(,%eax,4),%edx
  800609:	85 d2                	test   %edx,%edx
  80060b:	74 18                	je     800625 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80060d:	52                   	push   %edx
  80060e:	68 7e 10 80 00       	push   $0x80107e
  800613:	53                   	push   %ebx
  800614:	56                   	push   %esi
  800615:	e8 b3 fe ff ff       	call   8004cd <printfmt>
  80061a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80061d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800620:	e9 d9 02 00 00       	jmp    8008fe <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800625:	50                   	push   %eax
  800626:	68 75 10 80 00       	push   $0x801075
  80062b:	53                   	push   %ebx
  80062c:	56                   	push   %esi
  80062d:	e8 9b fe ff ff       	call   8004cd <printfmt>
  800632:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800635:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800638:	e9 c1 02 00 00       	jmp    8008fe <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	83 c0 04             	add    $0x4,%eax
  800643:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80064b:	85 ff                	test   %edi,%edi
  80064d:	b8 6e 10 80 00       	mov    $0x80106e,%eax
  800652:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800655:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800659:	0f 8e bd 00 00 00    	jle    80071c <vprintfmt+0x232>
  80065f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800663:	75 0e                	jne    800673 <vprintfmt+0x189>
  800665:	89 75 08             	mov    %esi,0x8(%ebp)
  800668:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80066b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80066e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800671:	eb 6d                	jmp    8006e0 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	ff 75 d0             	pushl  -0x30(%ebp)
  800679:	57                   	push   %edi
  80067a:	e8 ad 03 00 00       	call   800a2c <strnlen>
  80067f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800682:	29 c1                	sub    %eax,%ecx
  800684:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800687:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80068a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80068e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800691:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800694:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800696:	eb 0f                	jmp    8006a7 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	53                   	push   %ebx
  80069c:	ff 75 e0             	pushl  -0x20(%ebp)
  80069f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a1:	83 ef 01             	sub    $0x1,%edi
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	85 ff                	test   %edi,%edi
  8006a9:	7f ed                	jg     800698 <vprintfmt+0x1ae>
  8006ab:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006ae:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006b1:	85 c9                	test   %ecx,%ecx
  8006b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b8:	0f 49 c1             	cmovns %ecx,%eax
  8006bb:	29 c1                	sub    %eax,%ecx
  8006bd:	89 75 08             	mov    %esi,0x8(%ebp)
  8006c0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006c3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006c6:	89 cb                	mov    %ecx,%ebx
  8006c8:	eb 16                	jmp    8006e0 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ca:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006ce:	75 31                	jne    800701 <vprintfmt+0x217>
					putch(ch, putdat);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	50                   	push   %eax
  8006d7:	ff 55 08             	call   *0x8(%ebp)
  8006da:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006dd:	83 eb 01             	sub    $0x1,%ebx
  8006e0:	83 c7 01             	add    $0x1,%edi
  8006e3:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006e7:	0f be c2             	movsbl %dl,%eax
  8006ea:	85 c0                	test   %eax,%eax
  8006ec:	74 59                	je     800747 <vprintfmt+0x25d>
  8006ee:	85 f6                	test   %esi,%esi
  8006f0:	78 d8                	js     8006ca <vprintfmt+0x1e0>
  8006f2:	83 ee 01             	sub    $0x1,%esi
  8006f5:	79 d3                	jns    8006ca <vprintfmt+0x1e0>
  8006f7:	89 df                	mov    %ebx,%edi
  8006f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8006fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006ff:	eb 37                	jmp    800738 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800701:	0f be d2             	movsbl %dl,%edx
  800704:	83 ea 20             	sub    $0x20,%edx
  800707:	83 fa 5e             	cmp    $0x5e,%edx
  80070a:	76 c4                	jbe    8006d0 <vprintfmt+0x1e6>
					putch('?', putdat);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	ff 75 0c             	pushl  0xc(%ebp)
  800712:	6a 3f                	push   $0x3f
  800714:	ff 55 08             	call   *0x8(%ebp)
  800717:	83 c4 10             	add    $0x10,%esp
  80071a:	eb c1                	jmp    8006dd <vprintfmt+0x1f3>
  80071c:	89 75 08             	mov    %esi,0x8(%ebp)
  80071f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800722:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800725:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800728:	eb b6                	jmp    8006e0 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	53                   	push   %ebx
  80072e:	6a 20                	push   $0x20
  800730:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800732:	83 ef 01             	sub    $0x1,%edi
  800735:	83 c4 10             	add    $0x10,%esp
  800738:	85 ff                	test   %edi,%edi
  80073a:	7f ee                	jg     80072a <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80073c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
  800742:	e9 b7 01 00 00       	jmp    8008fe <vprintfmt+0x414>
  800747:	89 df                	mov    %ebx,%edi
  800749:	8b 75 08             	mov    0x8(%ebp),%esi
  80074c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80074f:	eb e7                	jmp    800738 <vprintfmt+0x24e>
	if (lflag >= 2)
  800751:	83 f9 01             	cmp    $0x1,%ecx
  800754:	7e 3f                	jle    800795 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8b 50 04             	mov    0x4(%eax),%edx
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800761:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8d 40 08             	lea    0x8(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80076d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800771:	79 5c                	jns    8007cf <vprintfmt+0x2e5>
				putch('-', putdat);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	53                   	push   %ebx
  800777:	6a 2d                	push   $0x2d
  800779:	ff d6                	call   *%esi
				num = -(long long) num;
  80077b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80077e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800781:	f7 da                	neg    %edx
  800783:	83 d1 00             	adc    $0x0,%ecx
  800786:	f7 d9                	neg    %ecx
  800788:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80078b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800790:	e9 4f 01 00 00       	jmp    8008e4 <vprintfmt+0x3fa>
	else if (lflag)
  800795:	85 c9                	test   %ecx,%ecx
  800797:	75 1b                	jne    8007b4 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a1:	89 c1                	mov    %eax,%ecx
  8007a3:	c1 f9 1f             	sar    $0x1f,%ecx
  8007a6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8d 40 04             	lea    0x4(%eax),%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b2:	eb b9                	jmp    80076d <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bc:	89 c1                	mov    %eax,%ecx
  8007be:	c1 f9 1f             	sar    $0x1f,%ecx
  8007c1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cd:	eb 9e                	jmp    80076d <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007d2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007da:	e9 05 01 00 00       	jmp    8008e4 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007df:	83 f9 01             	cmp    $0x1,%ecx
  8007e2:	7e 18                	jle    8007fc <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	8b 10                	mov    (%eax),%edx
  8007e9:	8b 48 04             	mov    0x4(%eax),%ecx
  8007ec:	8d 40 08             	lea    0x8(%eax),%eax
  8007ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f7:	e9 e8 00 00 00       	jmp    8008e4 <vprintfmt+0x3fa>
	else if (lflag)
  8007fc:	85 c9                	test   %ecx,%ecx
  8007fe:	75 1a                	jne    80081a <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8b 10                	mov    (%eax),%edx
  800805:	b9 00 00 00 00       	mov    $0x0,%ecx
  80080a:	8d 40 04             	lea    0x4(%eax),%eax
  80080d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800810:	b8 0a 00 00 00       	mov    $0xa,%eax
  800815:	e9 ca 00 00 00       	jmp    8008e4 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8b 10                	mov    (%eax),%edx
  80081f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800824:	8d 40 04             	lea    0x4(%eax),%eax
  800827:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80082a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082f:	e9 b0 00 00 00       	jmp    8008e4 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800834:	83 f9 01             	cmp    $0x1,%ecx
  800837:	7e 3c                	jle    800875 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	8b 50 04             	mov    0x4(%eax),%edx
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800844:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	8d 40 08             	lea    0x8(%eax),%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800850:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800854:	79 59                	jns    8008af <vprintfmt+0x3c5>
                putch('-', putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	53                   	push   %ebx
  80085a:	6a 2d                	push   $0x2d
  80085c:	ff d6                	call   *%esi
                num = -(long long) num;
  80085e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800861:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800864:	f7 da                	neg    %edx
  800866:	83 d1 00             	adc    $0x0,%ecx
  800869:	f7 d9                	neg    %ecx
  80086b:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80086e:	b8 08 00 00 00       	mov    $0x8,%eax
  800873:	eb 6f                	jmp    8008e4 <vprintfmt+0x3fa>
	else if (lflag)
  800875:	85 c9                	test   %ecx,%ecx
  800877:	75 1b                	jne    800894 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800881:	89 c1                	mov    %eax,%ecx
  800883:	c1 f9 1f             	sar    $0x1f,%ecx
  800886:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8d 40 04             	lea    0x4(%eax),%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
  800892:	eb bc                	jmp    800850 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	8b 00                	mov    (%eax),%eax
  800899:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089c:	89 c1                	mov    %eax,%ecx
  80089e:	c1 f9 1f             	sar    $0x1f,%ecx
  8008a1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a7:	8d 40 04             	lea    0x4(%eax),%eax
  8008aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ad:	eb a1                	jmp    800850 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8008af:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008b2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8008b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8008ba:	eb 28                	jmp    8008e4 <vprintfmt+0x3fa>
			putch('0', putdat);
  8008bc:	83 ec 08             	sub    $0x8,%esp
  8008bf:	53                   	push   %ebx
  8008c0:	6a 30                	push   $0x30
  8008c2:	ff d6                	call   *%esi
			putch('x', putdat);
  8008c4:	83 c4 08             	add    $0x8,%esp
  8008c7:	53                   	push   %ebx
  8008c8:	6a 78                	push   $0x78
  8008ca:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	8b 10                	mov    (%eax),%edx
  8008d1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008d6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008d9:	8d 40 04             	lea    0x4(%eax),%eax
  8008dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008df:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008e4:	83 ec 0c             	sub    $0xc,%esp
  8008e7:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008eb:	57                   	push   %edi
  8008ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8008ef:	50                   	push   %eax
  8008f0:	51                   	push   %ecx
  8008f1:	52                   	push   %edx
  8008f2:	89 da                	mov    %ebx,%edx
  8008f4:	89 f0                	mov    %esi,%eax
  8008f6:	e8 06 fb ff ff       	call   800401 <printnum>
			break;
  8008fb:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800901:	83 c7 01             	add    $0x1,%edi
  800904:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800908:	83 f8 25             	cmp    $0x25,%eax
  80090b:	0f 84 f0 fb ff ff    	je     800501 <vprintfmt+0x17>
			if (ch == '\0')
  800911:	85 c0                	test   %eax,%eax
  800913:	0f 84 8b 00 00 00    	je     8009a4 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	53                   	push   %ebx
  80091d:	50                   	push   %eax
  80091e:	ff d6                	call   *%esi
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	eb dc                	jmp    800901 <vprintfmt+0x417>
	if (lflag >= 2)
  800925:	83 f9 01             	cmp    $0x1,%ecx
  800928:	7e 15                	jle    80093f <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8b 10                	mov    (%eax),%edx
  80092f:	8b 48 04             	mov    0x4(%eax),%ecx
  800932:	8d 40 08             	lea    0x8(%eax),%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800938:	b8 10 00 00 00       	mov    $0x10,%eax
  80093d:	eb a5                	jmp    8008e4 <vprintfmt+0x3fa>
	else if (lflag)
  80093f:	85 c9                	test   %ecx,%ecx
  800941:	75 17                	jne    80095a <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	8b 10                	mov    (%eax),%edx
  800948:	b9 00 00 00 00       	mov    $0x0,%ecx
  80094d:	8d 40 04             	lea    0x4(%eax),%eax
  800950:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800953:	b8 10 00 00 00       	mov    $0x10,%eax
  800958:	eb 8a                	jmp    8008e4 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	8b 10                	mov    (%eax),%edx
  80095f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800964:	8d 40 04             	lea    0x4(%eax),%eax
  800967:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80096a:	b8 10 00 00 00       	mov    $0x10,%eax
  80096f:	e9 70 ff ff ff       	jmp    8008e4 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	53                   	push   %ebx
  800978:	6a 25                	push   $0x25
  80097a:	ff d6                	call   *%esi
			break;
  80097c:	83 c4 10             	add    $0x10,%esp
  80097f:	e9 7a ff ff ff       	jmp    8008fe <vprintfmt+0x414>
			putch('%', putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	53                   	push   %ebx
  800988:	6a 25                	push   $0x25
  80098a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80098c:	83 c4 10             	add    $0x10,%esp
  80098f:	89 f8                	mov    %edi,%eax
  800991:	eb 03                	jmp    800996 <vprintfmt+0x4ac>
  800993:	83 e8 01             	sub    $0x1,%eax
  800996:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80099a:	75 f7                	jne    800993 <vprintfmt+0x4a9>
  80099c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80099f:	e9 5a ff ff ff       	jmp    8008fe <vprintfmt+0x414>
}
  8009a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a7:	5b                   	pop    %ebx
  8009a8:	5e                   	pop    %esi
  8009a9:	5f                   	pop    %edi
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	83 ec 18             	sub    $0x18,%esp
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009bb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009bf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c9:	85 c0                	test   %eax,%eax
  8009cb:	74 26                	je     8009f3 <vsnprintf+0x47>
  8009cd:	85 d2                	test   %edx,%edx
  8009cf:	7e 22                	jle    8009f3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d1:	ff 75 14             	pushl  0x14(%ebp)
  8009d4:	ff 75 10             	pushl  0x10(%ebp)
  8009d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009da:	50                   	push   %eax
  8009db:	68 b0 04 80 00       	push   $0x8004b0
  8009e0:	e8 05 fb ff ff       	call   8004ea <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ee:	83 c4 10             	add    $0x10,%esp
}
  8009f1:	c9                   	leave  
  8009f2:	c3                   	ret    
		return -E_INVAL;
  8009f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f8:	eb f7                	jmp    8009f1 <vsnprintf+0x45>

008009fa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a00:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a03:	50                   	push   %eax
  800a04:	ff 75 10             	pushl  0x10(%ebp)
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	ff 75 08             	pushl  0x8(%ebp)
  800a0d:	e8 9a ff ff ff       	call   8009ac <vsnprintf>
	va_end(ap);

	return rc;
}
  800a12:	c9                   	leave  
  800a13:	c3                   	ret    

00800a14 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1f:	eb 03                	jmp    800a24 <strlen+0x10>
		n++;
  800a21:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a24:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a28:	75 f7                	jne    800a21 <strlen+0xd>
	return n;
}
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a32:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a35:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3a:	eb 03                	jmp    800a3f <strnlen+0x13>
		n++;
  800a3c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3f:	39 d0                	cmp    %edx,%eax
  800a41:	74 06                	je     800a49 <strnlen+0x1d>
  800a43:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a47:	75 f3                	jne    800a3c <strnlen+0x10>
	return n;
}
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	53                   	push   %ebx
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a55:	89 c2                	mov    %eax,%edx
  800a57:	83 c1 01             	add    $0x1,%ecx
  800a5a:	83 c2 01             	add    $0x1,%edx
  800a5d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a61:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a64:	84 db                	test   %bl,%bl
  800a66:	75 ef                	jne    800a57 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a68:	5b                   	pop    %ebx
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	53                   	push   %ebx
  800a6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a72:	53                   	push   %ebx
  800a73:	e8 9c ff ff ff       	call   800a14 <strlen>
  800a78:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	01 d8                	add    %ebx,%eax
  800a80:	50                   	push   %eax
  800a81:	e8 c5 ff ff ff       	call   800a4b <strcpy>
	return dst;
}
  800a86:	89 d8                	mov    %ebx,%eax
  800a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	56                   	push   %esi
  800a91:	53                   	push   %ebx
  800a92:	8b 75 08             	mov    0x8(%ebp),%esi
  800a95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a98:	89 f3                	mov    %esi,%ebx
  800a9a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a9d:	89 f2                	mov    %esi,%edx
  800a9f:	eb 0f                	jmp    800ab0 <strncpy+0x23>
		*dst++ = *src;
  800aa1:	83 c2 01             	add    $0x1,%edx
  800aa4:	0f b6 01             	movzbl (%ecx),%eax
  800aa7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aaa:	80 39 01             	cmpb   $0x1,(%ecx)
  800aad:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800ab0:	39 da                	cmp    %ebx,%edx
  800ab2:	75 ed                	jne    800aa1 <strncpy+0x14>
	}
	return ret;
}
  800ab4:	89 f0                	mov    %esi,%eax
  800ab6:	5b                   	pop    %ebx
  800ab7:	5e                   	pop    %esi
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	56                   	push   %esi
  800abe:	53                   	push   %ebx
  800abf:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ac8:	89 f0                	mov    %esi,%eax
  800aca:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ace:	85 c9                	test   %ecx,%ecx
  800ad0:	75 0b                	jne    800add <strlcpy+0x23>
  800ad2:	eb 17                	jmp    800aeb <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ad4:	83 c2 01             	add    $0x1,%edx
  800ad7:	83 c0 01             	add    $0x1,%eax
  800ada:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800add:	39 d8                	cmp    %ebx,%eax
  800adf:	74 07                	je     800ae8 <strlcpy+0x2e>
  800ae1:	0f b6 0a             	movzbl (%edx),%ecx
  800ae4:	84 c9                	test   %cl,%cl
  800ae6:	75 ec                	jne    800ad4 <strlcpy+0x1a>
		*dst = '\0';
  800ae8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aeb:	29 f0                	sub    %esi,%eax
}
  800aed:	5b                   	pop    %ebx
  800aee:	5e                   	pop    %esi
  800aef:	5d                   	pop    %ebp
  800af0:	c3                   	ret    

00800af1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800afa:	eb 06                	jmp    800b02 <strcmp+0x11>
		p++, q++;
  800afc:	83 c1 01             	add    $0x1,%ecx
  800aff:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b02:	0f b6 01             	movzbl (%ecx),%eax
  800b05:	84 c0                	test   %al,%al
  800b07:	74 04                	je     800b0d <strcmp+0x1c>
  800b09:	3a 02                	cmp    (%edx),%al
  800b0b:	74 ef                	je     800afc <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0d:	0f b6 c0             	movzbl %al,%eax
  800b10:	0f b6 12             	movzbl (%edx),%edx
  800b13:	29 d0                	sub    %edx,%eax
}
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	53                   	push   %ebx
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b21:	89 c3                	mov    %eax,%ebx
  800b23:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b26:	eb 06                	jmp    800b2e <strncmp+0x17>
		n--, p++, q++;
  800b28:	83 c0 01             	add    $0x1,%eax
  800b2b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b2e:	39 d8                	cmp    %ebx,%eax
  800b30:	74 16                	je     800b48 <strncmp+0x31>
  800b32:	0f b6 08             	movzbl (%eax),%ecx
  800b35:	84 c9                	test   %cl,%cl
  800b37:	74 04                	je     800b3d <strncmp+0x26>
  800b39:	3a 0a                	cmp    (%edx),%cl
  800b3b:	74 eb                	je     800b28 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b3d:	0f b6 00             	movzbl (%eax),%eax
  800b40:	0f b6 12             	movzbl (%edx),%edx
  800b43:	29 d0                	sub    %edx,%eax
}
  800b45:	5b                   	pop    %ebx
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    
		return 0;
  800b48:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4d:	eb f6                	jmp    800b45 <strncmp+0x2e>

00800b4f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b59:	0f b6 10             	movzbl (%eax),%edx
  800b5c:	84 d2                	test   %dl,%dl
  800b5e:	74 09                	je     800b69 <strchr+0x1a>
		if (*s == c)
  800b60:	38 ca                	cmp    %cl,%dl
  800b62:	74 0a                	je     800b6e <strchr+0x1f>
	for (; *s; s++)
  800b64:	83 c0 01             	add    $0x1,%eax
  800b67:	eb f0                	jmp    800b59 <strchr+0xa>
			return (char *) s;
	return 0;
  800b69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b7a:	eb 03                	jmp    800b7f <strfind+0xf>
  800b7c:	83 c0 01             	add    $0x1,%eax
  800b7f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b82:	38 ca                	cmp    %cl,%dl
  800b84:	74 04                	je     800b8a <strfind+0x1a>
  800b86:	84 d2                	test   %dl,%dl
  800b88:	75 f2                	jne    800b7c <strfind+0xc>
			break;
	return (char *) s;
}
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	57                   	push   %edi
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
  800b92:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b95:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b98:	85 c9                	test   %ecx,%ecx
  800b9a:	74 13                	je     800baf <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b9c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ba2:	75 05                	jne    800ba9 <memset+0x1d>
  800ba4:	f6 c1 03             	test   $0x3,%cl
  800ba7:	74 0d                	je     800bb6 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	fc                   	cld    
  800bad:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800baf:	89 f8                	mov    %edi,%eax
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    
		c &= 0xFF;
  800bb6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bba:	89 d3                	mov    %edx,%ebx
  800bbc:	c1 e3 08             	shl    $0x8,%ebx
  800bbf:	89 d0                	mov    %edx,%eax
  800bc1:	c1 e0 18             	shl    $0x18,%eax
  800bc4:	89 d6                	mov    %edx,%esi
  800bc6:	c1 e6 10             	shl    $0x10,%esi
  800bc9:	09 f0                	or     %esi,%eax
  800bcb:	09 c2                	or     %eax,%edx
  800bcd:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bcf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd2:	89 d0                	mov    %edx,%eax
  800bd4:	fc                   	cld    
  800bd5:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd7:	eb d6                	jmp    800baf <memset+0x23>

00800bd9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	57                   	push   %edi
  800bdd:	56                   	push   %esi
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be7:	39 c6                	cmp    %eax,%esi
  800be9:	73 35                	jae    800c20 <memmove+0x47>
  800beb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bee:	39 c2                	cmp    %eax,%edx
  800bf0:	76 2e                	jbe    800c20 <memmove+0x47>
		s += n;
		d += n;
  800bf2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf5:	89 d6                	mov    %edx,%esi
  800bf7:	09 fe                	or     %edi,%esi
  800bf9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bff:	74 0c                	je     800c0d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c01:	83 ef 01             	sub    $0x1,%edi
  800c04:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c07:	fd                   	std    
  800c08:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c0a:	fc                   	cld    
  800c0b:	eb 21                	jmp    800c2e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0d:	f6 c1 03             	test   $0x3,%cl
  800c10:	75 ef                	jne    800c01 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c12:	83 ef 04             	sub    $0x4,%edi
  800c15:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c18:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c1b:	fd                   	std    
  800c1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1e:	eb ea                	jmp    800c0a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c20:	89 f2                	mov    %esi,%edx
  800c22:	09 c2                	or     %eax,%edx
  800c24:	f6 c2 03             	test   $0x3,%dl
  800c27:	74 09                	je     800c32 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c29:	89 c7                	mov    %eax,%edi
  800c2b:	fc                   	cld    
  800c2c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c2e:	5e                   	pop    %esi
  800c2f:	5f                   	pop    %edi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c32:	f6 c1 03             	test   $0x3,%cl
  800c35:	75 f2                	jne    800c29 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c37:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c3a:	89 c7                	mov    %eax,%edi
  800c3c:	fc                   	cld    
  800c3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c3f:	eb ed                	jmp    800c2e <memmove+0x55>

00800c41 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c44:	ff 75 10             	pushl  0x10(%ebp)
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	ff 75 08             	pushl  0x8(%ebp)
  800c4d:	e8 87 ff ff ff       	call   800bd9 <memmove>
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5f:	89 c6                	mov    %eax,%esi
  800c61:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c64:	39 f0                	cmp    %esi,%eax
  800c66:	74 1c                	je     800c84 <memcmp+0x30>
		if (*s1 != *s2)
  800c68:	0f b6 08             	movzbl (%eax),%ecx
  800c6b:	0f b6 1a             	movzbl (%edx),%ebx
  800c6e:	38 d9                	cmp    %bl,%cl
  800c70:	75 08                	jne    800c7a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c72:	83 c0 01             	add    $0x1,%eax
  800c75:	83 c2 01             	add    $0x1,%edx
  800c78:	eb ea                	jmp    800c64 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c7a:	0f b6 c1             	movzbl %cl,%eax
  800c7d:	0f b6 db             	movzbl %bl,%ebx
  800c80:	29 d8                	sub    %ebx,%eax
  800c82:	eb 05                	jmp    800c89 <memcmp+0x35>
	}

	return 0;
  800c84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c89:	5b                   	pop    %ebx
  800c8a:	5e                   	pop    %esi
  800c8b:	5d                   	pop    %ebp
  800c8c:	c3                   	ret    

00800c8d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c96:	89 c2                	mov    %eax,%edx
  800c98:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c9b:	39 d0                	cmp    %edx,%eax
  800c9d:	73 09                	jae    800ca8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c9f:	38 08                	cmp    %cl,(%eax)
  800ca1:	74 05                	je     800ca8 <memfind+0x1b>
	for (; s < ends; s++)
  800ca3:	83 c0 01             	add    $0x1,%eax
  800ca6:	eb f3                	jmp    800c9b <memfind+0xe>
			break;
	return (void *) s;
}
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    

00800caa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	57                   	push   %edi
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
  800cb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb6:	eb 03                	jmp    800cbb <strtol+0x11>
		s++;
  800cb8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cbb:	0f b6 01             	movzbl (%ecx),%eax
  800cbe:	3c 20                	cmp    $0x20,%al
  800cc0:	74 f6                	je     800cb8 <strtol+0xe>
  800cc2:	3c 09                	cmp    $0x9,%al
  800cc4:	74 f2                	je     800cb8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cc6:	3c 2b                	cmp    $0x2b,%al
  800cc8:	74 2e                	je     800cf8 <strtol+0x4e>
	int neg = 0;
  800cca:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ccf:	3c 2d                	cmp    $0x2d,%al
  800cd1:	74 2f                	je     800d02 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cd3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cd9:	75 05                	jne    800ce0 <strtol+0x36>
  800cdb:	80 39 30             	cmpb   $0x30,(%ecx)
  800cde:	74 2c                	je     800d0c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ce0:	85 db                	test   %ebx,%ebx
  800ce2:	75 0a                	jne    800cee <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ce4:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ce9:	80 39 30             	cmpb   $0x30,(%ecx)
  800cec:	74 28                	je     800d16 <strtol+0x6c>
		base = 10;
  800cee:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cf6:	eb 50                	jmp    800d48 <strtol+0x9e>
		s++;
  800cf8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cfb:	bf 00 00 00 00       	mov    $0x0,%edi
  800d00:	eb d1                	jmp    800cd3 <strtol+0x29>
		s++, neg = 1;
  800d02:	83 c1 01             	add    $0x1,%ecx
  800d05:	bf 01 00 00 00       	mov    $0x1,%edi
  800d0a:	eb c7                	jmp    800cd3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d0c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d10:	74 0e                	je     800d20 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d12:	85 db                	test   %ebx,%ebx
  800d14:	75 d8                	jne    800cee <strtol+0x44>
		s++, base = 8;
  800d16:	83 c1 01             	add    $0x1,%ecx
  800d19:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d1e:	eb ce                	jmp    800cee <strtol+0x44>
		s += 2, base = 16;
  800d20:	83 c1 02             	add    $0x2,%ecx
  800d23:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d28:	eb c4                	jmp    800cee <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d2a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d2d:	89 f3                	mov    %esi,%ebx
  800d2f:	80 fb 19             	cmp    $0x19,%bl
  800d32:	77 29                	ja     800d5d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d34:	0f be d2             	movsbl %dl,%edx
  800d37:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d3a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d3d:	7d 30                	jge    800d6f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d3f:	83 c1 01             	add    $0x1,%ecx
  800d42:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d46:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d48:	0f b6 11             	movzbl (%ecx),%edx
  800d4b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d4e:	89 f3                	mov    %esi,%ebx
  800d50:	80 fb 09             	cmp    $0x9,%bl
  800d53:	77 d5                	ja     800d2a <strtol+0x80>
			dig = *s - '0';
  800d55:	0f be d2             	movsbl %dl,%edx
  800d58:	83 ea 30             	sub    $0x30,%edx
  800d5b:	eb dd                	jmp    800d3a <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d5d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d60:	89 f3                	mov    %esi,%ebx
  800d62:	80 fb 19             	cmp    $0x19,%bl
  800d65:	77 08                	ja     800d6f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d67:	0f be d2             	movsbl %dl,%edx
  800d6a:	83 ea 37             	sub    $0x37,%edx
  800d6d:	eb cb                	jmp    800d3a <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d73:	74 05                	je     800d7a <strtol+0xd0>
		*endptr = (char *) s;
  800d75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d78:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d7a:	89 c2                	mov    %eax,%edx
  800d7c:	f7 da                	neg    %edx
  800d7e:	85 ff                	test   %edi,%edi
  800d80:	0f 45 c2             	cmovne %edx,%eax
}
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800d8e:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800d95:	74 0a                	je     800da1 <set_pgfault_handler+0x19>
		// LAB 4: Your code here.
		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800d9f:	c9                   	leave  
  800da0:	c3                   	ret    
		panic("set_pgfault_handler not implemented");
  800da1:	83 ec 04             	sub    $0x4,%esp
  800da4:	68 a4 12 80 00       	push   $0x8012a4
  800da9:	6a 20                	push   $0x20
  800dab:	68 c8 12 80 00       	push   $0x8012c8
  800db0:	e8 5d f5 ff ff       	call   800312 <_panic>
  800db5:	66 90                	xchg   %ax,%ax
  800db7:	66 90                	xchg   %ax,%ax
  800db9:	66 90                	xchg   %ax,%ax
  800dbb:	66 90                	xchg   %ax,%ax
  800dbd:	66 90                	xchg   %ax,%ax
  800dbf:	90                   	nop

00800dc0 <__udivdi3>:
  800dc0:	55                   	push   %ebp
  800dc1:	57                   	push   %edi
  800dc2:	56                   	push   %esi
  800dc3:	53                   	push   %ebx
  800dc4:	83 ec 1c             	sub    $0x1c,%esp
  800dc7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800dcb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800dcf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800dd3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800dd7:	85 d2                	test   %edx,%edx
  800dd9:	75 35                	jne    800e10 <__udivdi3+0x50>
  800ddb:	39 f3                	cmp    %esi,%ebx
  800ddd:	0f 87 bd 00 00 00    	ja     800ea0 <__udivdi3+0xe0>
  800de3:	85 db                	test   %ebx,%ebx
  800de5:	89 d9                	mov    %ebx,%ecx
  800de7:	75 0b                	jne    800df4 <__udivdi3+0x34>
  800de9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dee:	31 d2                	xor    %edx,%edx
  800df0:	f7 f3                	div    %ebx
  800df2:	89 c1                	mov    %eax,%ecx
  800df4:	31 d2                	xor    %edx,%edx
  800df6:	89 f0                	mov    %esi,%eax
  800df8:	f7 f1                	div    %ecx
  800dfa:	89 c6                	mov    %eax,%esi
  800dfc:	89 e8                	mov    %ebp,%eax
  800dfe:	89 f7                	mov    %esi,%edi
  800e00:	f7 f1                	div    %ecx
  800e02:	89 fa                	mov    %edi,%edx
  800e04:	83 c4 1c             	add    $0x1c,%esp
  800e07:	5b                   	pop    %ebx
  800e08:	5e                   	pop    %esi
  800e09:	5f                   	pop    %edi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    
  800e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e10:	39 f2                	cmp    %esi,%edx
  800e12:	77 7c                	ja     800e90 <__udivdi3+0xd0>
  800e14:	0f bd fa             	bsr    %edx,%edi
  800e17:	83 f7 1f             	xor    $0x1f,%edi
  800e1a:	0f 84 98 00 00 00    	je     800eb8 <__udivdi3+0xf8>
  800e20:	89 f9                	mov    %edi,%ecx
  800e22:	b8 20 00 00 00       	mov    $0x20,%eax
  800e27:	29 f8                	sub    %edi,%eax
  800e29:	d3 e2                	shl    %cl,%edx
  800e2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e2f:	89 c1                	mov    %eax,%ecx
  800e31:	89 da                	mov    %ebx,%edx
  800e33:	d3 ea                	shr    %cl,%edx
  800e35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e39:	09 d1                	or     %edx,%ecx
  800e3b:	89 f2                	mov    %esi,%edx
  800e3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e41:	89 f9                	mov    %edi,%ecx
  800e43:	d3 e3                	shl    %cl,%ebx
  800e45:	89 c1                	mov    %eax,%ecx
  800e47:	d3 ea                	shr    %cl,%edx
  800e49:	89 f9                	mov    %edi,%ecx
  800e4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e4f:	d3 e6                	shl    %cl,%esi
  800e51:	89 eb                	mov    %ebp,%ebx
  800e53:	89 c1                	mov    %eax,%ecx
  800e55:	d3 eb                	shr    %cl,%ebx
  800e57:	09 de                	or     %ebx,%esi
  800e59:	89 f0                	mov    %esi,%eax
  800e5b:	f7 74 24 08          	divl   0x8(%esp)
  800e5f:	89 d6                	mov    %edx,%esi
  800e61:	89 c3                	mov    %eax,%ebx
  800e63:	f7 64 24 0c          	mull   0xc(%esp)
  800e67:	39 d6                	cmp    %edx,%esi
  800e69:	72 0c                	jb     800e77 <__udivdi3+0xb7>
  800e6b:	89 f9                	mov    %edi,%ecx
  800e6d:	d3 e5                	shl    %cl,%ebp
  800e6f:	39 c5                	cmp    %eax,%ebp
  800e71:	73 5d                	jae    800ed0 <__udivdi3+0x110>
  800e73:	39 d6                	cmp    %edx,%esi
  800e75:	75 59                	jne    800ed0 <__udivdi3+0x110>
  800e77:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e7a:	31 ff                	xor    %edi,%edi
  800e7c:	89 fa                	mov    %edi,%edx
  800e7e:	83 c4 1c             	add    $0x1c,%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    
  800e86:	8d 76 00             	lea    0x0(%esi),%esi
  800e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800e90:	31 ff                	xor    %edi,%edi
  800e92:	31 c0                	xor    %eax,%eax
  800e94:	89 fa                	mov    %edi,%edx
  800e96:	83 c4 1c             	add    $0x1c,%esp
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    
  800e9e:	66 90                	xchg   %ax,%ax
  800ea0:	31 ff                	xor    %edi,%edi
  800ea2:	89 e8                	mov    %ebp,%eax
  800ea4:	89 f2                	mov    %esi,%edx
  800ea6:	f7 f3                	div    %ebx
  800ea8:	89 fa                	mov    %edi,%edx
  800eaa:	83 c4 1c             	add    $0x1c,%esp
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    
  800eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800eb8:	39 f2                	cmp    %esi,%edx
  800eba:	72 06                	jb     800ec2 <__udivdi3+0x102>
  800ebc:	31 c0                	xor    %eax,%eax
  800ebe:	39 eb                	cmp    %ebp,%ebx
  800ec0:	77 d2                	ja     800e94 <__udivdi3+0xd4>
  800ec2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ec7:	eb cb                	jmp    800e94 <__udivdi3+0xd4>
  800ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ed0:	89 d8                	mov    %ebx,%eax
  800ed2:	31 ff                	xor    %edi,%edi
  800ed4:	eb be                	jmp    800e94 <__udivdi3+0xd4>
  800ed6:	66 90                	xchg   %ax,%ax
  800ed8:	66 90                	xchg   %ax,%ax
  800eda:	66 90                	xchg   %ax,%ax
  800edc:	66 90                	xchg   %ax,%ax
  800ede:	66 90                	xchg   %ax,%ax

00800ee0 <__umoddi3>:
  800ee0:	55                   	push   %ebp
  800ee1:	57                   	push   %edi
  800ee2:	56                   	push   %esi
  800ee3:	53                   	push   %ebx
  800ee4:	83 ec 1c             	sub    $0x1c,%esp
  800ee7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800eeb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800eef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ef3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ef7:	85 ed                	test   %ebp,%ebp
  800ef9:	89 f0                	mov    %esi,%eax
  800efb:	89 da                	mov    %ebx,%edx
  800efd:	75 19                	jne    800f18 <__umoddi3+0x38>
  800eff:	39 df                	cmp    %ebx,%edi
  800f01:	0f 86 b1 00 00 00    	jbe    800fb8 <__umoddi3+0xd8>
  800f07:	f7 f7                	div    %edi
  800f09:	89 d0                	mov    %edx,%eax
  800f0b:	31 d2                	xor    %edx,%edx
  800f0d:	83 c4 1c             	add    $0x1c,%esp
  800f10:	5b                   	pop    %ebx
  800f11:	5e                   	pop    %esi
  800f12:	5f                   	pop    %edi
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    
  800f15:	8d 76 00             	lea    0x0(%esi),%esi
  800f18:	39 dd                	cmp    %ebx,%ebp
  800f1a:	77 f1                	ja     800f0d <__umoddi3+0x2d>
  800f1c:	0f bd cd             	bsr    %ebp,%ecx
  800f1f:	83 f1 1f             	xor    $0x1f,%ecx
  800f22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f26:	0f 84 b4 00 00 00    	je     800fe0 <__umoddi3+0x100>
  800f2c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f31:	89 c2                	mov    %eax,%edx
  800f33:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f37:	29 c2                	sub    %eax,%edx
  800f39:	89 c1                	mov    %eax,%ecx
  800f3b:	89 f8                	mov    %edi,%eax
  800f3d:	d3 e5                	shl    %cl,%ebp
  800f3f:	89 d1                	mov    %edx,%ecx
  800f41:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f45:	d3 e8                	shr    %cl,%eax
  800f47:	09 c5                	or     %eax,%ebp
  800f49:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f4d:	89 c1                	mov    %eax,%ecx
  800f4f:	d3 e7                	shl    %cl,%edi
  800f51:	89 d1                	mov    %edx,%ecx
  800f53:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f57:	89 df                	mov    %ebx,%edi
  800f59:	d3 ef                	shr    %cl,%edi
  800f5b:	89 c1                	mov    %eax,%ecx
  800f5d:	89 f0                	mov    %esi,%eax
  800f5f:	d3 e3                	shl    %cl,%ebx
  800f61:	89 d1                	mov    %edx,%ecx
  800f63:	89 fa                	mov    %edi,%edx
  800f65:	d3 e8                	shr    %cl,%eax
  800f67:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f6c:	09 d8                	or     %ebx,%eax
  800f6e:	f7 f5                	div    %ebp
  800f70:	d3 e6                	shl    %cl,%esi
  800f72:	89 d1                	mov    %edx,%ecx
  800f74:	f7 64 24 08          	mull   0x8(%esp)
  800f78:	39 d1                	cmp    %edx,%ecx
  800f7a:	89 c3                	mov    %eax,%ebx
  800f7c:	89 d7                	mov    %edx,%edi
  800f7e:	72 06                	jb     800f86 <__umoddi3+0xa6>
  800f80:	75 0e                	jne    800f90 <__umoddi3+0xb0>
  800f82:	39 c6                	cmp    %eax,%esi
  800f84:	73 0a                	jae    800f90 <__umoddi3+0xb0>
  800f86:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f8a:	19 ea                	sbb    %ebp,%edx
  800f8c:	89 d7                	mov    %edx,%edi
  800f8e:	89 c3                	mov    %eax,%ebx
  800f90:	89 ca                	mov    %ecx,%edx
  800f92:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f97:	29 de                	sub    %ebx,%esi
  800f99:	19 fa                	sbb    %edi,%edx
  800f9b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800f9f:	89 d0                	mov    %edx,%eax
  800fa1:	d3 e0                	shl    %cl,%eax
  800fa3:	89 d9                	mov    %ebx,%ecx
  800fa5:	d3 ee                	shr    %cl,%esi
  800fa7:	d3 ea                	shr    %cl,%edx
  800fa9:	09 f0                	or     %esi,%eax
  800fab:	83 c4 1c             	add    $0x1c,%esp
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    
  800fb3:	90                   	nop
  800fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800fb8:	85 ff                	test   %edi,%edi
  800fba:	89 f9                	mov    %edi,%ecx
  800fbc:	75 0b                	jne    800fc9 <__umoddi3+0xe9>
  800fbe:	b8 01 00 00 00       	mov    $0x1,%eax
  800fc3:	31 d2                	xor    %edx,%edx
  800fc5:	f7 f7                	div    %edi
  800fc7:	89 c1                	mov    %eax,%ecx
  800fc9:	89 d8                	mov    %ebx,%eax
  800fcb:	31 d2                	xor    %edx,%edx
  800fcd:	f7 f1                	div    %ecx
  800fcf:	89 f0                	mov    %esi,%eax
  800fd1:	f7 f1                	div    %ecx
  800fd3:	e9 31 ff ff ff       	jmp    800f09 <__umoddi3+0x29>
  800fd8:	90                   	nop
  800fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fe0:	39 dd                	cmp    %ebx,%ebp
  800fe2:	72 08                	jb     800fec <__umoddi3+0x10c>
  800fe4:	39 f7                	cmp    %esi,%edi
  800fe6:	0f 87 21 ff ff ff    	ja     800f0d <__umoddi3+0x2d>
  800fec:	89 da                	mov    %ebx,%edx
  800fee:	89 f0                	mov    %esi,%eax
  800ff0:	29 f8                	sub    %edi,%eax
  800ff2:	19 ea                	sbb    %ebp,%edx
  800ff4:	e9 14 ff ff ff       	jmp    800f0d <__umoddi3+0x2d>
