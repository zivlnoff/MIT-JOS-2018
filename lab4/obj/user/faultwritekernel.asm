
obj/user/faultwritekernel：     文件格式 elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	*(unsigned*)0xf0100000 = 0;
  800036:	c7 05 00 00 10 f0 00 	movl   $0x0,0xf0100000
  80003d:	00 00 00 
}
  800040:	5d                   	pop    %ebp
  800041:	c3                   	ret    

00800042 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	83 ec 08             	sub    $0x8,%esp
  800048:	8b 45 08             	mov    0x8(%ebp),%eax
  80004b:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  80004e:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  800055:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800058:	85 c0                	test   %eax,%eax
  80005a:	7e 08                	jle    800064 <libmain+0x22>
		binaryname = argv[0];
  80005c:	8b 0a                	mov    (%edx),%ecx
  80005e:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  800064:	83 ec 08             	sub    $0x8,%esp
  800067:	52                   	push   %edx
  800068:	50                   	push   %eax
  800069:	e8 c5 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80006e:	e8 05 00 00 00       	call   800078 <exit>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	c9                   	leave  
  800077:	c3                   	ret    

00800078 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800078:	55                   	push   %ebp
  800079:	89 e5                	mov    %esp,%ebp
  80007b:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80007e:	6a 00                	push   $0x0
  800080:	e8 42 00 00 00       	call   8000c7 <sys_env_destroy>
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	c9                   	leave  
  800089:	c3                   	ret    

0080008a <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80008a:	55                   	push   %ebp
  80008b:	89 e5                	mov    %esp,%ebp
  80008d:	57                   	push   %edi
  80008e:	56                   	push   %esi
  80008f:	53                   	push   %ebx
    asm volatile("int %1\n"
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	8b 55 08             	mov    0x8(%ebp),%edx
  800098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80009b:	89 c3                	mov    %eax,%ebx
  80009d:	89 c7                	mov    %eax,%edi
  80009f:	89 c6                	mov    %eax,%esi
  8000a1:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000a3:	5b                   	pop    %ebx
  8000a4:	5e                   	pop    %esi
  8000a5:	5f                   	pop    %edi
  8000a6:	5d                   	pop    %ebp
  8000a7:	c3                   	ret    

008000a8 <sys_cgetc>:

int
sys_cgetc(void) {
  8000a8:	55                   	push   %ebp
  8000a9:	89 e5                	mov    %esp,%ebp
  8000ab:	57                   	push   %edi
  8000ac:	56                   	push   %esi
  8000ad:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b8:	89 d1                	mov    %edx,%ecx
  8000ba:	89 d3                	mov    %edx,%ebx
  8000bc:	89 d7                	mov    %edx,%edi
  8000be:	89 d6                	mov    %edx,%esi
  8000c0:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000c2:	5b                   	pop    %ebx
  8000c3:	5e                   	pop    %esi
  8000c4:	5f                   	pop    %edi
  8000c5:	5d                   	pop    %ebp
  8000c6:	c3                   	ret    

008000c7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	57                   	push   %edi
  8000cb:	56                   	push   %esi
  8000cc:	53                   	push   %ebx
  8000cd:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d8:	b8 03 00 00 00       	mov    $0x3,%eax
  8000dd:	89 cb                	mov    %ecx,%ebx
  8000df:	89 cf                	mov    %ecx,%edi
  8000e1:	89 ce                	mov    %ecx,%esi
  8000e3:	cd 30                	int    $0x30
    if (check && ret > 0)
  8000e5:	85 c0                	test   %eax,%eax
  8000e7:	7f 08                	jg     8000f1 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5f                   	pop    %edi
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	50                   	push   %eax
  8000f5:	6a 03                	push   $0x3
  8000f7:	68 ca 0f 80 00       	push   $0x800fca
  8000fc:	6a 24                	push   $0x24
  8000fe:	68 e7 0f 80 00       	push   $0x800fe7
  800103:	e8 ed 01 00 00       	call   8002f5 <_panic>

00800108 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	57                   	push   %edi
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
    asm volatile("int %1\n"
  80010e:	ba 00 00 00 00       	mov    $0x0,%edx
  800113:	b8 02 00 00 00       	mov    $0x2,%eax
  800118:	89 d1                	mov    %edx,%ecx
  80011a:	89 d3                	mov    %edx,%ebx
  80011c:	89 d7                	mov    %edx,%edi
  80011e:	89 d6                	mov    %edx,%esi
  800120:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800122:	5b                   	pop    %ebx
  800123:	5e                   	pop    %esi
  800124:	5f                   	pop    %edi
  800125:	5d                   	pop    %ebp
  800126:	c3                   	ret    

00800127 <sys_yield>:

void
sys_yield(void)
{
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	57                   	push   %edi
  80012b:	56                   	push   %esi
  80012c:	53                   	push   %ebx
    asm volatile("int %1\n"
  80012d:	ba 00 00 00 00       	mov    $0x0,%edx
  800132:	b8 0a 00 00 00       	mov    $0xa,%eax
  800137:	89 d1                	mov    %edx,%ecx
  800139:	89 d3                	mov    %edx,%ebx
  80013b:	89 d7                	mov    %edx,%edi
  80013d:	89 d6                	mov    %edx,%esi
  80013f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800141:	5b                   	pop    %ebx
  800142:	5e                   	pop    %esi
  800143:	5f                   	pop    %edi
  800144:	5d                   	pop    %ebp
  800145:	c3                   	ret    

00800146 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	57                   	push   %edi
  80014a:	56                   	push   %esi
  80014b:	53                   	push   %ebx
  80014c:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80014f:	be 00 00 00 00       	mov    $0x0,%esi
  800154:	8b 55 08             	mov    0x8(%ebp),%edx
  800157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80015a:	b8 04 00 00 00       	mov    $0x4,%eax
  80015f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800162:	89 f7                	mov    %esi,%edi
  800164:	cd 30                	int    $0x30
    if (check && ret > 0)
  800166:	85 c0                	test   %eax,%eax
  800168:	7f 08                	jg     800172 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80016a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80016d:	5b                   	pop    %ebx
  80016e:	5e                   	pop    %esi
  80016f:	5f                   	pop    %edi
  800170:	5d                   	pop    %ebp
  800171:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	50                   	push   %eax
  800176:	6a 04                	push   $0x4
  800178:	68 ca 0f 80 00       	push   $0x800fca
  80017d:	6a 24                	push   $0x24
  80017f:	68 e7 0f 80 00       	push   $0x800fe7
  800184:	e8 6c 01 00 00       	call   8002f5 <_panic>

00800189 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800189:	55                   	push   %ebp
  80018a:	89 e5                	mov    %esp,%ebp
  80018c:	57                   	push   %edi
  80018d:	56                   	push   %esi
  80018e:	53                   	push   %ebx
  80018f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800192:	8b 55 08             	mov    0x8(%ebp),%edx
  800195:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800198:	b8 05 00 00 00       	mov    $0x5,%eax
  80019d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8001a6:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001a8:	85 c0                	test   %eax,%eax
  8001aa:	7f 08                	jg     8001b4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001af:	5b                   	pop    %ebx
  8001b0:	5e                   	pop    %esi
  8001b1:	5f                   	pop    %edi
  8001b2:	5d                   	pop    %ebp
  8001b3:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	50                   	push   %eax
  8001b8:	6a 05                	push   $0x5
  8001ba:	68 ca 0f 80 00       	push   $0x800fca
  8001bf:	6a 24                	push   $0x24
  8001c1:	68 e7 0f 80 00       	push   $0x800fe7
  8001c6:	e8 2a 01 00 00       	call   8002f5 <_panic>

008001cb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001cb:	55                   	push   %ebp
  8001cc:	89 e5                	mov    %esp,%ebp
  8001ce:	57                   	push   %edi
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001df:	b8 06 00 00 00       	mov    $0x6,%eax
  8001e4:	89 df                	mov    %ebx,%edi
  8001e6:	89 de                	mov    %ebx,%esi
  8001e8:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001ea:	85 c0                	test   %eax,%eax
  8001ec:	7f 08                	jg     8001f6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f1:	5b                   	pop    %ebx
  8001f2:	5e                   	pop    %esi
  8001f3:	5f                   	pop    %edi
  8001f4:	5d                   	pop    %ebp
  8001f5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	50                   	push   %eax
  8001fa:	6a 06                	push   $0x6
  8001fc:	68 ca 0f 80 00       	push   $0x800fca
  800201:	6a 24                	push   $0x24
  800203:	68 e7 0f 80 00       	push   $0x800fe7
  800208:	e8 e8 00 00 00       	call   8002f5 <_panic>

0080020d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80020d:	55                   	push   %ebp
  80020e:	89 e5                	mov    %esp,%ebp
  800210:	57                   	push   %edi
  800211:	56                   	push   %esi
  800212:	53                   	push   %ebx
  800213:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800216:	bb 00 00 00 00       	mov    $0x0,%ebx
  80021b:	8b 55 08             	mov    0x8(%ebp),%edx
  80021e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800221:	b8 08 00 00 00       	mov    $0x8,%eax
  800226:	89 df                	mov    %ebx,%edi
  800228:	89 de                	mov    %ebx,%esi
  80022a:	cd 30                	int    $0x30
    if (check && ret > 0)
  80022c:	85 c0                	test   %eax,%eax
  80022e:	7f 08                	jg     800238 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800230:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800233:	5b                   	pop    %ebx
  800234:	5e                   	pop    %esi
  800235:	5f                   	pop    %edi
  800236:	5d                   	pop    %ebp
  800237:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	50                   	push   %eax
  80023c:	6a 08                	push   $0x8
  80023e:	68 ca 0f 80 00       	push   $0x800fca
  800243:	6a 24                	push   $0x24
  800245:	68 e7 0f 80 00       	push   $0x800fe7
  80024a:	e8 a6 00 00 00       	call   8002f5 <_panic>

0080024f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	57                   	push   %edi
  800253:	56                   	push   %esi
  800254:	53                   	push   %ebx
  800255:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800258:	bb 00 00 00 00       	mov    $0x0,%ebx
  80025d:	8b 55 08             	mov    0x8(%ebp),%edx
  800260:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800263:	b8 09 00 00 00       	mov    $0x9,%eax
  800268:	89 df                	mov    %ebx,%edi
  80026a:	89 de                	mov    %ebx,%esi
  80026c:	cd 30                	int    $0x30
    if (check && ret > 0)
  80026e:	85 c0                	test   %eax,%eax
  800270:	7f 08                	jg     80027a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80027a:	83 ec 0c             	sub    $0xc,%esp
  80027d:	50                   	push   %eax
  80027e:	6a 09                	push   $0x9
  800280:	68 ca 0f 80 00       	push   $0x800fca
  800285:	6a 24                	push   $0x24
  800287:	68 e7 0f 80 00       	push   $0x800fe7
  80028c:	e8 64 00 00 00       	call   8002f5 <_panic>

00800291 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	57                   	push   %edi
  800295:	56                   	push   %esi
  800296:	53                   	push   %ebx
    asm volatile("int %1\n"
  800297:	8b 55 08             	mov    0x8(%ebp),%edx
  80029a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80029d:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002a2:	be 00 00 00 00       	mov    $0x0,%esi
  8002a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002aa:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002ad:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002af:	5b                   	pop    %ebx
  8002b0:	5e                   	pop    %esi
  8002b1:	5f                   	pop    %edi
  8002b2:	5d                   	pop    %ebp
  8002b3:	c3                   	ret    

008002b4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	57                   	push   %edi
  8002b8:	56                   	push   %esi
  8002b9:	53                   	push   %ebx
  8002ba:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ca:	89 cb                	mov    %ecx,%ebx
  8002cc:	89 cf                	mov    %ecx,%edi
  8002ce:	89 ce                	mov    %ecx,%esi
  8002d0:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002d2:	85 c0                	test   %eax,%eax
  8002d4:	7f 08                	jg     8002de <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	50                   	push   %eax
  8002e2:	6a 0c                	push   $0xc
  8002e4:	68 ca 0f 80 00       	push   $0x800fca
  8002e9:	6a 24                	push   $0x24
  8002eb:	68 e7 0f 80 00       	push   $0x800fe7
  8002f0:	e8 00 00 00 00       	call   8002f5 <_panic>

008002f5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002fa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002fd:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800303:	e8 00 fe ff ff       	call   800108 <sys_getenvid>
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	ff 75 0c             	pushl  0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	56                   	push   %esi
  800312:	50                   	push   %eax
  800313:	68 f8 0f 80 00       	push   $0x800ff8
  800318:	e8 b3 00 00 00       	call   8003d0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80031d:	83 c4 18             	add    $0x18,%esp
  800320:	53                   	push   %ebx
  800321:	ff 75 10             	pushl  0x10(%ebp)
  800324:	e8 56 00 00 00       	call   80037f <vcprintf>
	cprintf("\n");
  800329:	c7 04 24 1c 10 80 00 	movl   $0x80101c,(%esp)
  800330:	e8 9b 00 00 00       	call   8003d0 <cprintf>
  800335:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800338:	cc                   	int3   
  800339:	eb fd                	jmp    800338 <_panic+0x43>

0080033b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80033b:	55                   	push   %ebp
  80033c:	89 e5                	mov    %esp,%ebp
  80033e:	53                   	push   %ebx
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800345:	8b 13                	mov    (%ebx),%edx
  800347:	8d 42 01             	lea    0x1(%edx),%eax
  80034a:	89 03                	mov    %eax,(%ebx)
  80034c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80034f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800353:	3d ff 00 00 00       	cmp    $0xff,%eax
  800358:	74 09                	je     800363 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80035a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80035e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800361:	c9                   	leave  
  800362:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800363:	83 ec 08             	sub    $0x8,%esp
  800366:	68 ff 00 00 00       	push   $0xff
  80036b:	8d 43 08             	lea    0x8(%ebx),%eax
  80036e:	50                   	push   %eax
  80036f:	e8 16 fd ff ff       	call   80008a <sys_cputs>
		b->idx = 0;
  800374:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80037a:	83 c4 10             	add    $0x10,%esp
  80037d:	eb db                	jmp    80035a <putch+0x1f>

0080037f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800388:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80038f:	00 00 00 
	b.cnt = 0;
  800392:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800399:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80039c:	ff 75 0c             	pushl  0xc(%ebp)
  80039f:	ff 75 08             	pushl  0x8(%ebp)
  8003a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003a8:	50                   	push   %eax
  8003a9:	68 3b 03 80 00       	push   $0x80033b
  8003ae:	e8 1a 01 00 00       	call   8004cd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003b3:	83 c4 08             	add    $0x8,%esp
  8003b6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003bc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003c2:	50                   	push   %eax
  8003c3:	e8 c2 fc ff ff       	call   80008a <sys_cputs>

	return b.cnt;
}
  8003c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003ce:	c9                   	leave  
  8003cf:	c3                   	ret    

008003d0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003d6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003d9:	50                   	push   %eax
  8003da:	ff 75 08             	pushl  0x8(%ebp)
  8003dd:	e8 9d ff ff ff       	call   80037f <vcprintf>
	va_end(ap);

	return cnt;
}
  8003e2:	c9                   	leave  
  8003e3:	c3                   	ret    

008003e4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	57                   	push   %edi
  8003e8:	56                   	push   %esi
  8003e9:	53                   	push   %ebx
  8003ea:	83 ec 1c             	sub    $0x1c,%esp
  8003ed:	89 c7                	mov    %eax,%edi
  8003ef:	89 d6                	mov    %edx,%esi
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  8003fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800400:	bb 00 00 00 00       	mov    $0x0,%ebx
  800405:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800408:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80040b:	39 d3                	cmp    %edx,%ebx
  80040d:	72 05                	jb     800414 <printnum+0x30>
  80040f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800412:	77 7a                	ja     80048e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800414:	83 ec 0c             	sub    $0xc,%esp
  800417:	ff 75 18             	pushl  0x18(%ebp)
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800420:	53                   	push   %ebx
  800421:	ff 75 10             	pushl  0x10(%ebp)
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	ff 75 e4             	pushl  -0x1c(%ebp)
  80042a:	ff 75 e0             	pushl  -0x20(%ebp)
  80042d:	ff 75 dc             	pushl  -0x24(%ebp)
  800430:	ff 75 d8             	pushl  -0x28(%ebp)
  800433:	e8 38 09 00 00       	call   800d70 <__udivdi3>
  800438:	83 c4 18             	add    $0x18,%esp
  80043b:	52                   	push   %edx
  80043c:	50                   	push   %eax
  80043d:	89 f2                	mov    %esi,%edx
  80043f:	89 f8                	mov    %edi,%eax
  800441:	e8 9e ff ff ff       	call   8003e4 <printnum>
  800446:	83 c4 20             	add    $0x20,%esp
  800449:	eb 13                	jmp    80045e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	56                   	push   %esi
  80044f:	ff 75 18             	pushl  0x18(%ebp)
  800452:	ff d7                	call   *%edi
  800454:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800457:	83 eb 01             	sub    $0x1,%ebx
  80045a:	85 db                	test   %ebx,%ebx
  80045c:	7f ed                	jg     80044b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	56                   	push   %esi
  800462:	83 ec 04             	sub    $0x4,%esp
  800465:	ff 75 e4             	pushl  -0x1c(%ebp)
  800468:	ff 75 e0             	pushl  -0x20(%ebp)
  80046b:	ff 75 dc             	pushl  -0x24(%ebp)
  80046e:	ff 75 d8             	pushl  -0x28(%ebp)
  800471:	e8 1a 0a 00 00       	call   800e90 <__umoddi3>
  800476:	83 c4 14             	add    $0x14,%esp
  800479:	0f be 80 1e 10 80 00 	movsbl 0x80101e(%eax),%eax
  800480:	50                   	push   %eax
  800481:	ff d7                	call   *%edi
}
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800489:	5b                   	pop    %ebx
  80048a:	5e                   	pop    %esi
  80048b:	5f                   	pop    %edi
  80048c:	5d                   	pop    %ebp
  80048d:	c3                   	ret    
  80048e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800491:	eb c4                	jmp    800457 <printnum+0x73>

00800493 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
  800496:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800499:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80049d:	8b 10                	mov    (%eax),%edx
  80049f:	3b 50 04             	cmp    0x4(%eax),%edx
  8004a2:	73 0a                	jae    8004ae <sprintputch+0x1b>
		*b->buf++ = ch;
  8004a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004a7:	89 08                	mov    %ecx,(%eax)
  8004a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ac:	88 02                	mov    %al,(%edx)
}
  8004ae:	5d                   	pop    %ebp
  8004af:	c3                   	ret    

008004b0 <printfmt>:
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004b6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004b9:	50                   	push   %eax
  8004ba:	ff 75 10             	pushl  0x10(%ebp)
  8004bd:	ff 75 0c             	pushl  0xc(%ebp)
  8004c0:	ff 75 08             	pushl  0x8(%ebp)
  8004c3:	e8 05 00 00 00       	call   8004cd <vprintfmt>
}
  8004c8:	83 c4 10             	add    $0x10,%esp
  8004cb:	c9                   	leave  
  8004cc:	c3                   	ret    

008004cd <vprintfmt>:
{
  8004cd:	55                   	push   %ebp
  8004ce:	89 e5                	mov    %esp,%ebp
  8004d0:	57                   	push   %edi
  8004d1:	56                   	push   %esi
  8004d2:	53                   	push   %ebx
  8004d3:	83 ec 2c             	sub    $0x2c,%esp
  8004d6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004dc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004df:	e9 00 04 00 00       	jmp    8008e4 <vprintfmt+0x417>
		padc = ' ';
  8004e4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8004e8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8004ef:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8004f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004fd:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800502:	8d 47 01             	lea    0x1(%edi),%eax
  800505:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800508:	0f b6 17             	movzbl (%edi),%edx
  80050b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80050e:	3c 55                	cmp    $0x55,%al
  800510:	0f 87 51 04 00 00    	ja     800967 <vprintfmt+0x49a>
  800516:	0f b6 c0             	movzbl %al,%eax
  800519:	ff 24 85 e0 10 80 00 	jmp    *0x8010e0(,%eax,4)
  800520:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800523:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800527:	eb d9                	jmp    800502 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800529:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80052c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800530:	eb d0                	jmp    800502 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800532:	0f b6 d2             	movzbl %dl,%edx
  800535:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800538:	b8 00 00 00 00       	mov    $0x0,%eax
  80053d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800540:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800543:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800547:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80054a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80054d:	83 f9 09             	cmp    $0x9,%ecx
  800550:	77 55                	ja     8005a7 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800552:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800555:	eb e9                	jmp    800540 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8d 40 04             	lea    0x4(%eax),%eax
  800565:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800568:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80056b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80056f:	79 91                	jns    800502 <vprintfmt+0x35>
				width = precision, precision = -1;
  800571:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800574:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800577:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80057e:	eb 82                	jmp    800502 <vprintfmt+0x35>
  800580:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800583:	85 c0                	test   %eax,%eax
  800585:	ba 00 00 00 00       	mov    $0x0,%edx
  80058a:	0f 49 d0             	cmovns %eax,%edx
  80058d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800590:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800593:	e9 6a ff ff ff       	jmp    800502 <vprintfmt+0x35>
  800598:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80059b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005a2:	e9 5b ff ff ff       	jmp    800502 <vprintfmt+0x35>
  8005a7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ad:	eb bc                	jmp    80056b <vprintfmt+0x9e>
			lflag++;
  8005af:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005b5:	e9 48 ff ff ff       	jmp    800502 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8d 78 04             	lea    0x4(%eax),%edi
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	53                   	push   %ebx
  8005c4:	ff 30                	pushl  (%eax)
  8005c6:	ff d6                	call   *%esi
			break;
  8005c8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005cb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005ce:	e9 0e 03 00 00       	jmp    8008e1 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8d 78 04             	lea    0x4(%eax),%edi
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	99                   	cltd   
  8005dc:	31 d0                	xor    %edx,%eax
  8005de:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005e0:	83 f8 08             	cmp    $0x8,%eax
  8005e3:	7f 23                	jg     800608 <vprintfmt+0x13b>
  8005e5:	8b 14 85 40 12 80 00 	mov    0x801240(,%eax,4),%edx
  8005ec:	85 d2                	test   %edx,%edx
  8005ee:	74 18                	je     800608 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8005f0:	52                   	push   %edx
  8005f1:	68 3f 10 80 00       	push   $0x80103f
  8005f6:	53                   	push   %ebx
  8005f7:	56                   	push   %esi
  8005f8:	e8 b3 fe ff ff       	call   8004b0 <printfmt>
  8005fd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800600:	89 7d 14             	mov    %edi,0x14(%ebp)
  800603:	e9 d9 02 00 00       	jmp    8008e1 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800608:	50                   	push   %eax
  800609:	68 36 10 80 00       	push   $0x801036
  80060e:	53                   	push   %ebx
  80060f:	56                   	push   %esi
  800610:	e8 9b fe ff ff       	call   8004b0 <printfmt>
  800615:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800618:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80061b:	e9 c1 02 00 00       	jmp    8008e1 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	83 c0 04             	add    $0x4,%eax
  800626:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80062e:	85 ff                	test   %edi,%edi
  800630:	b8 2f 10 80 00       	mov    $0x80102f,%eax
  800635:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800638:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80063c:	0f 8e bd 00 00 00    	jle    8006ff <vprintfmt+0x232>
  800642:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800646:	75 0e                	jne    800656 <vprintfmt+0x189>
  800648:	89 75 08             	mov    %esi,0x8(%ebp)
  80064b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80064e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800651:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800654:	eb 6d                	jmp    8006c3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800656:	83 ec 08             	sub    $0x8,%esp
  800659:	ff 75 d0             	pushl  -0x30(%ebp)
  80065c:	57                   	push   %edi
  80065d:	e8 ad 03 00 00       	call   800a0f <strnlen>
  800662:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800665:	29 c1                	sub    %eax,%ecx
  800667:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80066a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80066d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800671:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800674:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800677:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800679:	eb 0f                	jmp    80068a <vprintfmt+0x1bd>
					putch(padc, putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	ff 75 e0             	pushl  -0x20(%ebp)
  800682:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800684:	83 ef 01             	sub    $0x1,%edi
  800687:	83 c4 10             	add    $0x10,%esp
  80068a:	85 ff                	test   %edi,%edi
  80068c:	7f ed                	jg     80067b <vprintfmt+0x1ae>
  80068e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800691:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800694:	85 c9                	test   %ecx,%ecx
  800696:	b8 00 00 00 00       	mov    $0x0,%eax
  80069b:	0f 49 c1             	cmovns %ecx,%eax
  80069e:	29 c1                	sub    %eax,%ecx
  8006a0:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006a6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006a9:	89 cb                	mov    %ecx,%ebx
  8006ab:	eb 16                	jmp    8006c3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ad:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006b1:	75 31                	jne    8006e4 <vprintfmt+0x217>
					putch(ch, putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	50                   	push   %eax
  8006ba:	ff 55 08             	call   *0x8(%ebp)
  8006bd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c0:	83 eb 01             	sub    $0x1,%ebx
  8006c3:	83 c7 01             	add    $0x1,%edi
  8006c6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006ca:	0f be c2             	movsbl %dl,%eax
  8006cd:	85 c0                	test   %eax,%eax
  8006cf:	74 59                	je     80072a <vprintfmt+0x25d>
  8006d1:	85 f6                	test   %esi,%esi
  8006d3:	78 d8                	js     8006ad <vprintfmt+0x1e0>
  8006d5:	83 ee 01             	sub    $0x1,%esi
  8006d8:	79 d3                	jns    8006ad <vprintfmt+0x1e0>
  8006da:	89 df                	mov    %ebx,%edi
  8006dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8006df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006e2:	eb 37                	jmp    80071b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e4:	0f be d2             	movsbl %dl,%edx
  8006e7:	83 ea 20             	sub    $0x20,%edx
  8006ea:	83 fa 5e             	cmp    $0x5e,%edx
  8006ed:	76 c4                	jbe    8006b3 <vprintfmt+0x1e6>
					putch('?', putdat);
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	6a 3f                	push   $0x3f
  8006f7:	ff 55 08             	call   *0x8(%ebp)
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	eb c1                	jmp    8006c0 <vprintfmt+0x1f3>
  8006ff:	89 75 08             	mov    %esi,0x8(%ebp)
  800702:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800705:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800708:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80070b:	eb b6                	jmp    8006c3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	53                   	push   %ebx
  800711:	6a 20                	push   $0x20
  800713:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800715:	83 ef 01             	sub    $0x1,%edi
  800718:	83 c4 10             	add    $0x10,%esp
  80071b:	85 ff                	test   %edi,%edi
  80071d:	7f ee                	jg     80070d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80071f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800722:	89 45 14             	mov    %eax,0x14(%ebp)
  800725:	e9 b7 01 00 00       	jmp    8008e1 <vprintfmt+0x414>
  80072a:	89 df                	mov    %ebx,%edi
  80072c:	8b 75 08             	mov    0x8(%ebp),%esi
  80072f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800732:	eb e7                	jmp    80071b <vprintfmt+0x24e>
	if (lflag >= 2)
  800734:	83 f9 01             	cmp    $0x1,%ecx
  800737:	7e 3f                	jle    800778 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8b 50 04             	mov    0x4(%eax),%edx
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800744:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 40 08             	lea    0x8(%eax),%eax
  80074d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800750:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800754:	79 5c                	jns    8007b2 <vprintfmt+0x2e5>
				putch('-', putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	53                   	push   %ebx
  80075a:	6a 2d                	push   $0x2d
  80075c:	ff d6                	call   *%esi
				num = -(long long) num;
  80075e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800761:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800764:	f7 da                	neg    %edx
  800766:	83 d1 00             	adc    $0x0,%ecx
  800769:	f7 d9                	neg    %ecx
  80076b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80076e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800773:	e9 4f 01 00 00       	jmp    8008c7 <vprintfmt+0x3fa>
	else if (lflag)
  800778:	85 c9                	test   %ecx,%ecx
  80077a:	75 1b                	jne    800797 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800784:	89 c1                	mov    %eax,%ecx
  800786:	c1 f9 1f             	sar    $0x1f,%ecx
  800789:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8d 40 04             	lea    0x4(%eax),%eax
  800792:	89 45 14             	mov    %eax,0x14(%ebp)
  800795:	eb b9                	jmp    800750 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8b 00                	mov    (%eax),%eax
  80079c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079f:	89 c1                	mov    %eax,%ecx
  8007a1:	c1 f9 1f             	sar    $0x1f,%ecx
  8007a4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8d 40 04             	lea    0x4(%eax),%eax
  8007ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b0:	eb 9e                	jmp    800750 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007b5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007bd:	e9 05 01 00 00       	jmp    8008c7 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007c2:	83 f9 01             	cmp    $0x1,%ecx
  8007c5:	7e 18                	jle    8007df <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8b 10                	mov    (%eax),%edx
  8007cc:	8b 48 04             	mov    0x4(%eax),%ecx
  8007cf:	8d 40 08             	lea    0x8(%eax),%eax
  8007d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007da:	e9 e8 00 00 00       	jmp    8008c7 <vprintfmt+0x3fa>
	else if (lflag)
  8007df:	85 c9                	test   %ecx,%ecx
  8007e1:	75 1a                	jne    8007fd <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8b 10                	mov    (%eax),%edx
  8007e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ed:	8d 40 04             	lea    0x4(%eax),%eax
  8007f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f8:	e9 ca 00 00 00       	jmp    8008c7 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8b 10                	mov    (%eax),%edx
  800802:	b9 00 00 00 00       	mov    $0x0,%ecx
  800807:	8d 40 04             	lea    0x4(%eax),%eax
  80080a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80080d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800812:	e9 b0 00 00 00       	jmp    8008c7 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800817:	83 f9 01             	cmp    $0x1,%ecx
  80081a:	7e 3c                	jle    800858 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 50 04             	mov    0x4(%eax),%edx
  800822:	8b 00                	mov    (%eax),%eax
  800824:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800827:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082a:	8b 45 14             	mov    0x14(%ebp),%eax
  80082d:	8d 40 08             	lea    0x8(%eax),%eax
  800830:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800833:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800837:	79 59                	jns    800892 <vprintfmt+0x3c5>
                putch('-', putdat);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	53                   	push   %ebx
  80083d:	6a 2d                	push   $0x2d
  80083f:	ff d6                	call   *%esi
                num = -(long long) num;
  800841:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800844:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800847:	f7 da                	neg    %edx
  800849:	83 d1 00             	adc    $0x0,%ecx
  80084c:	f7 d9                	neg    %ecx
  80084e:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800851:	b8 08 00 00 00       	mov    $0x8,%eax
  800856:	eb 6f                	jmp    8008c7 <vprintfmt+0x3fa>
	else if (lflag)
  800858:	85 c9                	test   %ecx,%ecx
  80085a:	75 1b                	jne    800877 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800864:	89 c1                	mov    %eax,%ecx
  800866:	c1 f9 1f             	sar    $0x1f,%ecx
  800869:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8d 40 04             	lea    0x4(%eax),%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
  800875:	eb bc                	jmp    800833 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087f:	89 c1                	mov    %eax,%ecx
  800881:	c1 f9 1f             	sar    $0x1f,%ecx
  800884:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8d 40 04             	lea    0x4(%eax),%eax
  80088d:	89 45 14             	mov    %eax,0x14(%ebp)
  800890:	eb a1                	jmp    800833 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800892:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800895:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  800898:	b8 08 00 00 00       	mov    $0x8,%eax
  80089d:	eb 28                	jmp    8008c7 <vprintfmt+0x3fa>
			putch('0', putdat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	53                   	push   %ebx
  8008a3:	6a 30                	push   $0x30
  8008a5:	ff d6                	call   *%esi
			putch('x', putdat);
  8008a7:	83 c4 08             	add    $0x8,%esp
  8008aa:	53                   	push   %ebx
  8008ab:	6a 78                	push   $0x78
  8008ad:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008af:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b2:	8b 10                	mov    (%eax),%edx
  8008b4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008b9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008bc:	8d 40 04             	lea    0x4(%eax),%eax
  8008bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008c7:	83 ec 0c             	sub    $0xc,%esp
  8008ca:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008ce:	57                   	push   %edi
  8008cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8008d2:	50                   	push   %eax
  8008d3:	51                   	push   %ecx
  8008d4:	52                   	push   %edx
  8008d5:	89 da                	mov    %ebx,%edx
  8008d7:	89 f0                	mov    %esi,%eax
  8008d9:	e8 06 fb ff ff       	call   8003e4 <printnum>
			break;
  8008de:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e4:	83 c7 01             	add    $0x1,%edi
  8008e7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008eb:	83 f8 25             	cmp    $0x25,%eax
  8008ee:	0f 84 f0 fb ff ff    	je     8004e4 <vprintfmt+0x17>
			if (ch == '\0')
  8008f4:	85 c0                	test   %eax,%eax
  8008f6:	0f 84 8b 00 00 00    	je     800987 <vprintfmt+0x4ba>
			putch(ch, putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	53                   	push   %ebx
  800900:	50                   	push   %eax
  800901:	ff d6                	call   *%esi
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	eb dc                	jmp    8008e4 <vprintfmt+0x417>
	if (lflag >= 2)
  800908:	83 f9 01             	cmp    $0x1,%ecx
  80090b:	7e 15                	jle    800922 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	8b 10                	mov    (%eax),%edx
  800912:	8b 48 04             	mov    0x4(%eax),%ecx
  800915:	8d 40 08             	lea    0x8(%eax),%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091b:	b8 10 00 00 00       	mov    $0x10,%eax
  800920:	eb a5                	jmp    8008c7 <vprintfmt+0x3fa>
	else if (lflag)
  800922:	85 c9                	test   %ecx,%ecx
  800924:	75 17                	jne    80093d <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	8b 10                	mov    (%eax),%edx
  80092b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800930:	8d 40 04             	lea    0x4(%eax),%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800936:	b8 10 00 00 00       	mov    $0x10,%eax
  80093b:	eb 8a                	jmp    8008c7 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8b 10                	mov    (%eax),%edx
  800942:	b9 00 00 00 00       	mov    $0x0,%ecx
  800947:	8d 40 04             	lea    0x4(%eax),%eax
  80094a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80094d:	b8 10 00 00 00       	mov    $0x10,%eax
  800952:	e9 70 ff ff ff       	jmp    8008c7 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800957:	83 ec 08             	sub    $0x8,%esp
  80095a:	53                   	push   %ebx
  80095b:	6a 25                	push   $0x25
  80095d:	ff d6                	call   *%esi
			break;
  80095f:	83 c4 10             	add    $0x10,%esp
  800962:	e9 7a ff ff ff       	jmp    8008e1 <vprintfmt+0x414>
			putch('%', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	53                   	push   %ebx
  80096b:	6a 25                	push   $0x25
  80096d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	89 f8                	mov    %edi,%eax
  800974:	eb 03                	jmp    800979 <vprintfmt+0x4ac>
  800976:	83 e8 01             	sub    $0x1,%eax
  800979:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80097d:	75 f7                	jne    800976 <vprintfmt+0x4a9>
  80097f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800982:	e9 5a ff ff ff       	jmp    8008e1 <vprintfmt+0x414>
}
  800987:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80098a:	5b                   	pop    %ebx
  80098b:	5e                   	pop    %esi
  80098c:	5f                   	pop    %edi
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	83 ec 18             	sub    $0x18,%esp
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80099b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80099e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009a2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ac:	85 c0                	test   %eax,%eax
  8009ae:	74 26                	je     8009d6 <vsnprintf+0x47>
  8009b0:	85 d2                	test   %edx,%edx
  8009b2:	7e 22                	jle    8009d6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b4:	ff 75 14             	pushl  0x14(%ebp)
  8009b7:	ff 75 10             	pushl  0x10(%ebp)
  8009ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	68 93 04 80 00       	push   $0x800493
  8009c3:	e8 05 fb ff ff       	call   8004cd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
}
  8009d4:	c9                   	leave  
  8009d5:	c3                   	ret    
		return -E_INVAL;
  8009d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009db:	eb f7                	jmp    8009d4 <vsnprintf+0x45>

008009dd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 10             	pushl  0x10(%ebp)
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 9a ff ff ff       	call   80098f <vsnprintf>
	va_end(ap);

	return rc;
}
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800a02:	eb 03                	jmp    800a07 <strlen+0x10>
		n++;
  800a04:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a07:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a0b:	75 f7                	jne    800a04 <strlen+0xd>
	return n;
}
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a15:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a18:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1d:	eb 03                	jmp    800a22 <strnlen+0x13>
		n++;
  800a1f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a22:	39 d0                	cmp    %edx,%eax
  800a24:	74 06                	je     800a2c <strnlen+0x1d>
  800a26:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a2a:	75 f3                	jne    800a1f <strnlen+0x10>
	return n;
}
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	53                   	push   %ebx
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a38:	89 c2                	mov    %eax,%edx
  800a3a:	83 c1 01             	add    $0x1,%ecx
  800a3d:	83 c2 01             	add    $0x1,%edx
  800a40:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a44:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a47:	84 db                	test   %bl,%bl
  800a49:	75 ef                	jne    800a3a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a4b:	5b                   	pop    %ebx
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	53                   	push   %ebx
  800a52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a55:	53                   	push   %ebx
  800a56:	e8 9c ff ff ff       	call   8009f7 <strlen>
  800a5b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	01 d8                	add    %ebx,%eax
  800a63:	50                   	push   %eax
  800a64:	e8 c5 ff ff ff       	call   800a2e <strcpy>
	return dst;
}
  800a69:	89 d8                	mov    %ebx,%eax
  800a6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	56                   	push   %esi
  800a74:	53                   	push   %ebx
  800a75:	8b 75 08             	mov    0x8(%ebp),%esi
  800a78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a7b:	89 f3                	mov    %esi,%ebx
  800a7d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a80:	89 f2                	mov    %esi,%edx
  800a82:	eb 0f                	jmp    800a93 <strncpy+0x23>
		*dst++ = *src;
  800a84:	83 c2 01             	add    $0x1,%edx
  800a87:	0f b6 01             	movzbl (%ecx),%eax
  800a8a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a8d:	80 39 01             	cmpb   $0x1,(%ecx)
  800a90:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a93:	39 da                	cmp    %ebx,%edx
  800a95:	75 ed                	jne    800a84 <strncpy+0x14>
	}
	return ret;
}
  800a97:	89 f0                	mov    %esi,%eax
  800a99:	5b                   	pop    %ebx
  800a9a:	5e                   	pop    %esi
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    

00800a9d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
  800aa2:	8b 75 08             	mov    0x8(%ebp),%esi
  800aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800aab:	89 f0                	mov    %esi,%eax
  800aad:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ab1:	85 c9                	test   %ecx,%ecx
  800ab3:	75 0b                	jne    800ac0 <strlcpy+0x23>
  800ab5:	eb 17                	jmp    800ace <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ab7:	83 c2 01             	add    $0x1,%edx
  800aba:	83 c0 01             	add    $0x1,%eax
  800abd:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ac0:	39 d8                	cmp    %ebx,%eax
  800ac2:	74 07                	je     800acb <strlcpy+0x2e>
  800ac4:	0f b6 0a             	movzbl (%edx),%ecx
  800ac7:	84 c9                	test   %cl,%cl
  800ac9:	75 ec                	jne    800ab7 <strlcpy+0x1a>
		*dst = '\0';
  800acb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ace:	29 f0                	sub    %esi,%eax
}
  800ad0:	5b                   	pop    %ebx
  800ad1:	5e                   	pop    %esi
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ada:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800add:	eb 06                	jmp    800ae5 <strcmp+0x11>
		p++, q++;
  800adf:	83 c1 01             	add    $0x1,%ecx
  800ae2:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800ae5:	0f b6 01             	movzbl (%ecx),%eax
  800ae8:	84 c0                	test   %al,%al
  800aea:	74 04                	je     800af0 <strcmp+0x1c>
  800aec:	3a 02                	cmp    (%edx),%al
  800aee:	74 ef                	je     800adf <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af0:	0f b6 c0             	movzbl %al,%eax
  800af3:	0f b6 12             	movzbl (%edx),%edx
  800af6:	29 d0                	sub    %edx,%eax
}
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	53                   	push   %ebx
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b04:	89 c3                	mov    %eax,%ebx
  800b06:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b09:	eb 06                	jmp    800b11 <strncmp+0x17>
		n--, p++, q++;
  800b0b:	83 c0 01             	add    $0x1,%eax
  800b0e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b11:	39 d8                	cmp    %ebx,%eax
  800b13:	74 16                	je     800b2b <strncmp+0x31>
  800b15:	0f b6 08             	movzbl (%eax),%ecx
  800b18:	84 c9                	test   %cl,%cl
  800b1a:	74 04                	je     800b20 <strncmp+0x26>
  800b1c:	3a 0a                	cmp    (%edx),%cl
  800b1e:	74 eb                	je     800b0b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b20:	0f b6 00             	movzbl (%eax),%eax
  800b23:	0f b6 12             	movzbl (%edx),%edx
  800b26:	29 d0                	sub    %edx,%eax
}
  800b28:	5b                   	pop    %ebx
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    
		return 0;
  800b2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b30:	eb f6                	jmp    800b28 <strncmp+0x2e>

00800b32 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b3c:	0f b6 10             	movzbl (%eax),%edx
  800b3f:	84 d2                	test   %dl,%dl
  800b41:	74 09                	je     800b4c <strchr+0x1a>
		if (*s == c)
  800b43:	38 ca                	cmp    %cl,%dl
  800b45:	74 0a                	je     800b51 <strchr+0x1f>
	for (; *s; s++)
  800b47:	83 c0 01             	add    $0x1,%eax
  800b4a:	eb f0                	jmp    800b3c <strchr+0xa>
			return (char *) s;
	return 0;
  800b4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b5d:	eb 03                	jmp    800b62 <strfind+0xf>
  800b5f:	83 c0 01             	add    $0x1,%eax
  800b62:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b65:	38 ca                	cmp    %cl,%dl
  800b67:	74 04                	je     800b6d <strfind+0x1a>
  800b69:	84 d2                	test   %dl,%dl
  800b6b:	75 f2                	jne    800b5f <strfind+0xc>
			break;
	return (char *) s;
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	57                   	push   %edi
  800b73:	56                   	push   %esi
  800b74:	53                   	push   %ebx
  800b75:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b78:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b7b:	85 c9                	test   %ecx,%ecx
  800b7d:	74 13                	je     800b92 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b7f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b85:	75 05                	jne    800b8c <memset+0x1d>
  800b87:	f6 c1 03             	test   $0x3,%cl
  800b8a:	74 0d                	je     800b99 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8f:	fc                   	cld    
  800b90:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b92:	89 f8                	mov    %edi,%eax
  800b94:	5b                   	pop    %ebx
  800b95:	5e                   	pop    %esi
  800b96:	5f                   	pop    %edi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    
		c &= 0xFF;
  800b99:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b9d:	89 d3                	mov    %edx,%ebx
  800b9f:	c1 e3 08             	shl    $0x8,%ebx
  800ba2:	89 d0                	mov    %edx,%eax
  800ba4:	c1 e0 18             	shl    $0x18,%eax
  800ba7:	89 d6                	mov    %edx,%esi
  800ba9:	c1 e6 10             	shl    $0x10,%esi
  800bac:	09 f0                	or     %esi,%eax
  800bae:	09 c2                	or     %eax,%edx
  800bb0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bb2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bb5:	89 d0                	mov    %edx,%eax
  800bb7:	fc                   	cld    
  800bb8:	f3 ab                	rep stos %eax,%es:(%edi)
  800bba:	eb d6                	jmp    800b92 <memset+0x23>

00800bbc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	57                   	push   %edi
  800bc0:	56                   	push   %esi
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bca:	39 c6                	cmp    %eax,%esi
  800bcc:	73 35                	jae    800c03 <memmove+0x47>
  800bce:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bd1:	39 c2                	cmp    %eax,%edx
  800bd3:	76 2e                	jbe    800c03 <memmove+0x47>
		s += n;
		d += n;
  800bd5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd8:	89 d6                	mov    %edx,%esi
  800bda:	09 fe                	or     %edi,%esi
  800bdc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800be2:	74 0c                	je     800bf0 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800be4:	83 ef 01             	sub    $0x1,%edi
  800be7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bea:	fd                   	std    
  800beb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bed:	fc                   	cld    
  800bee:	eb 21                	jmp    800c11 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf0:	f6 c1 03             	test   $0x3,%cl
  800bf3:	75 ef                	jne    800be4 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bf5:	83 ef 04             	sub    $0x4,%edi
  800bf8:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bfb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bfe:	fd                   	std    
  800bff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c01:	eb ea                	jmp    800bed <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c03:	89 f2                	mov    %esi,%edx
  800c05:	09 c2                	or     %eax,%edx
  800c07:	f6 c2 03             	test   $0x3,%dl
  800c0a:	74 09                	je     800c15 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c0c:	89 c7                	mov    %eax,%edi
  800c0e:	fc                   	cld    
  800c0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c15:	f6 c1 03             	test   $0x3,%cl
  800c18:	75 f2                	jne    800c0c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c1a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c1d:	89 c7                	mov    %eax,%edi
  800c1f:	fc                   	cld    
  800c20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c22:	eb ed                	jmp    800c11 <memmove+0x55>

00800c24 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c27:	ff 75 10             	pushl  0x10(%ebp)
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	ff 75 08             	pushl  0x8(%ebp)
  800c30:	e8 87 ff ff ff       	call   800bbc <memmove>
}
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c42:	89 c6                	mov    %eax,%esi
  800c44:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c47:	39 f0                	cmp    %esi,%eax
  800c49:	74 1c                	je     800c67 <memcmp+0x30>
		if (*s1 != *s2)
  800c4b:	0f b6 08             	movzbl (%eax),%ecx
  800c4e:	0f b6 1a             	movzbl (%edx),%ebx
  800c51:	38 d9                	cmp    %bl,%cl
  800c53:	75 08                	jne    800c5d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c55:	83 c0 01             	add    $0x1,%eax
  800c58:	83 c2 01             	add    $0x1,%edx
  800c5b:	eb ea                	jmp    800c47 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c5d:	0f b6 c1             	movzbl %cl,%eax
  800c60:	0f b6 db             	movzbl %bl,%ebx
  800c63:	29 d8                	sub    %ebx,%eax
  800c65:	eb 05                	jmp    800c6c <memcmp+0x35>
	}

	return 0;
  800c67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c6c:	5b                   	pop    %ebx
  800c6d:	5e                   	pop    %esi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    

00800c70 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c79:	89 c2                	mov    %eax,%edx
  800c7b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c7e:	39 d0                	cmp    %edx,%eax
  800c80:	73 09                	jae    800c8b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c82:	38 08                	cmp    %cl,(%eax)
  800c84:	74 05                	je     800c8b <memfind+0x1b>
	for (; s < ends; s++)
  800c86:	83 c0 01             	add    $0x1,%eax
  800c89:	eb f3                	jmp    800c7e <memfind+0xe>
			break;
	return (void *) s;
}
  800c8b:	5d                   	pop    %ebp
  800c8c:	c3                   	ret    

00800c8d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	57                   	push   %edi
  800c91:	56                   	push   %esi
  800c92:	53                   	push   %ebx
  800c93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c99:	eb 03                	jmp    800c9e <strtol+0x11>
		s++;
  800c9b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c9e:	0f b6 01             	movzbl (%ecx),%eax
  800ca1:	3c 20                	cmp    $0x20,%al
  800ca3:	74 f6                	je     800c9b <strtol+0xe>
  800ca5:	3c 09                	cmp    $0x9,%al
  800ca7:	74 f2                	je     800c9b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ca9:	3c 2b                	cmp    $0x2b,%al
  800cab:	74 2e                	je     800cdb <strtol+0x4e>
	int neg = 0;
  800cad:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cb2:	3c 2d                	cmp    $0x2d,%al
  800cb4:	74 2f                	je     800ce5 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cbc:	75 05                	jne    800cc3 <strtol+0x36>
  800cbe:	80 39 30             	cmpb   $0x30,(%ecx)
  800cc1:	74 2c                	je     800cef <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cc3:	85 db                	test   %ebx,%ebx
  800cc5:	75 0a                	jne    800cd1 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cc7:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ccc:	80 39 30             	cmpb   $0x30,(%ecx)
  800ccf:	74 28                	je     800cf9 <strtol+0x6c>
		base = 10;
  800cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cd9:	eb 50                	jmp    800d2b <strtol+0x9e>
		s++;
  800cdb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cde:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce3:	eb d1                	jmp    800cb6 <strtol+0x29>
		s++, neg = 1;
  800ce5:	83 c1 01             	add    $0x1,%ecx
  800ce8:	bf 01 00 00 00       	mov    $0x1,%edi
  800ced:	eb c7                	jmp    800cb6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cef:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cf3:	74 0e                	je     800d03 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800cf5:	85 db                	test   %ebx,%ebx
  800cf7:	75 d8                	jne    800cd1 <strtol+0x44>
		s++, base = 8;
  800cf9:	83 c1 01             	add    $0x1,%ecx
  800cfc:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d01:	eb ce                	jmp    800cd1 <strtol+0x44>
		s += 2, base = 16;
  800d03:	83 c1 02             	add    $0x2,%ecx
  800d06:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d0b:	eb c4                	jmp    800cd1 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d0d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d10:	89 f3                	mov    %esi,%ebx
  800d12:	80 fb 19             	cmp    $0x19,%bl
  800d15:	77 29                	ja     800d40 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d17:	0f be d2             	movsbl %dl,%edx
  800d1a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d1d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d20:	7d 30                	jge    800d52 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d22:	83 c1 01             	add    $0x1,%ecx
  800d25:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d29:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d2b:	0f b6 11             	movzbl (%ecx),%edx
  800d2e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d31:	89 f3                	mov    %esi,%ebx
  800d33:	80 fb 09             	cmp    $0x9,%bl
  800d36:	77 d5                	ja     800d0d <strtol+0x80>
			dig = *s - '0';
  800d38:	0f be d2             	movsbl %dl,%edx
  800d3b:	83 ea 30             	sub    $0x30,%edx
  800d3e:	eb dd                	jmp    800d1d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d40:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d43:	89 f3                	mov    %esi,%ebx
  800d45:	80 fb 19             	cmp    $0x19,%bl
  800d48:	77 08                	ja     800d52 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d4a:	0f be d2             	movsbl %dl,%edx
  800d4d:	83 ea 37             	sub    $0x37,%edx
  800d50:	eb cb                	jmp    800d1d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d56:	74 05                	je     800d5d <strtol+0xd0>
		*endptr = (char *) s;
  800d58:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d5b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d5d:	89 c2                	mov    %eax,%edx
  800d5f:	f7 da                	neg    %edx
  800d61:	85 ff                	test   %edi,%edi
  800d63:	0f 45 c2             	cmovne %edx,%eax
}
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5f                   	pop    %edi
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    
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
