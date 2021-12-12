
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
  80003d:	e8 4d 00 00 00       	call   80008f <sys_cputs>
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
  80004a:	83 ec 08             	sub    $0x8,%esp
  80004d:	8b 45 08             	mov    0x8(%ebp),%eax
  800050:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  800053:	c7 05 04 20 80 00 00 	movl   $0xeec00000,0x802004
  80005a:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005d:	85 c0                	test   %eax,%eax
  80005f:	7e 08                	jle    800069 <libmain+0x22>
		binaryname = argv[0];
  800061:	8b 0a                	mov    (%edx),%ecx
  800063:	89 0d 00 20 80 00    	mov    %ecx,0x802000

	// call user main routine
	umain(argc, argv);
  800069:	83 ec 08             	sub    $0x8,%esp
  80006c:	52                   	push   %edx
  80006d:	50                   	push   %eax
  80006e:	e8 c0 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800073:	e8 05 00 00 00       	call   80007d <exit>
}
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	c9                   	leave  
  80007c:	c3                   	ret    

0080007d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007d:	55                   	push   %ebp
  80007e:	89 e5                	mov    %esp,%ebp
  800080:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  800083:	6a 00                	push   $0x0
  800085:	e8 42 00 00 00       	call   8000cc <sys_env_destroy>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	c9                   	leave  
  80008e:	c3                   	ret    

0080008f <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80008f:	55                   	push   %ebp
  800090:	89 e5                	mov    %esp,%ebp
  800092:	57                   	push   %edi
  800093:	56                   	push   %esi
  800094:	53                   	push   %ebx
    asm volatile("int %1\n"
  800095:	b8 00 00 00 00       	mov    $0x0,%eax
  80009a:	8b 55 08             	mov    0x8(%ebp),%edx
  80009d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a0:	89 c3                	mov    %eax,%ebx
  8000a2:	89 c7                	mov    %eax,%edi
  8000a4:	89 c6                	mov    %eax,%esi
  8000a6:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000a8:	5b                   	pop    %ebx
  8000a9:	5e                   	pop    %esi
  8000aa:	5f                   	pop    %edi
  8000ab:	5d                   	pop    %ebp
  8000ac:	c3                   	ret    

008000ad <sys_cgetc>:

int
sys_cgetc(void) {
  8000ad:	55                   	push   %ebp
  8000ae:	89 e5                	mov    %esp,%ebp
  8000b0:	57                   	push   %edi
  8000b1:	56                   	push   %esi
  8000b2:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8000bd:	89 d1                	mov    %edx,%ecx
  8000bf:	89 d3                	mov    %edx,%ebx
  8000c1:	89 d7                	mov    %edx,%edi
  8000c3:	89 d6                	mov    %edx,%esi
  8000c5:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000c7:	5b                   	pop    %ebx
  8000c8:	5e                   	pop    %esi
  8000c9:	5f                   	pop    %edi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    

008000cc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	57                   	push   %edi
  8000d0:	56                   	push   %esi
  8000d1:	53                   	push   %ebx
  8000d2:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000da:	8b 55 08             	mov    0x8(%ebp),%edx
  8000dd:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e2:	89 cb                	mov    %ecx,%ebx
  8000e4:	89 cf                	mov    %ecx,%edi
  8000e6:	89 ce                	mov    %ecx,%esi
  8000e8:	cd 30                	int    $0x30
    if (check && ret > 0)
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	7f 08                	jg     8000f6 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f1:	5b                   	pop    %ebx
  8000f2:	5e                   	pop    %esi
  8000f3:	5f                   	pop    %edi
  8000f4:	5d                   	pop    %ebp
  8000f5:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	50                   	push   %eax
  8000fa:	6a 03                	push   $0x3
  8000fc:	68 ca 0f 80 00       	push   $0x800fca
  800101:	6a 24                	push   $0x24
  800103:	68 e7 0f 80 00       	push   $0x800fe7
  800108:	e8 ed 01 00 00       	call   8002fa <_panic>

0080010d <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80010d:	55                   	push   %ebp
  80010e:	89 e5                	mov    %esp,%ebp
  800110:	57                   	push   %edi
  800111:	56                   	push   %esi
  800112:	53                   	push   %ebx
    asm volatile("int %1\n"
  800113:	ba 00 00 00 00       	mov    $0x0,%edx
  800118:	b8 02 00 00 00       	mov    $0x2,%eax
  80011d:	89 d1                	mov    %edx,%ecx
  80011f:	89 d3                	mov    %edx,%ebx
  800121:	89 d7                	mov    %edx,%edi
  800123:	89 d6                	mov    %edx,%esi
  800125:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800127:	5b                   	pop    %ebx
  800128:	5e                   	pop    %esi
  800129:	5f                   	pop    %edi
  80012a:	5d                   	pop    %ebp
  80012b:	c3                   	ret    

0080012c <sys_yield>:

void
sys_yield(void)
{
  80012c:	55                   	push   %ebp
  80012d:	89 e5                	mov    %esp,%ebp
  80012f:	57                   	push   %edi
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
    asm volatile("int %1\n"
  800132:	ba 00 00 00 00       	mov    $0x0,%edx
  800137:	b8 0a 00 00 00       	mov    $0xa,%eax
  80013c:	89 d1                	mov    %edx,%ecx
  80013e:	89 d3                	mov    %edx,%ebx
  800140:	89 d7                	mov    %edx,%edi
  800142:	89 d6                	mov    %edx,%esi
  800144:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800146:	5b                   	pop    %ebx
  800147:	5e                   	pop    %esi
  800148:	5f                   	pop    %edi
  800149:	5d                   	pop    %ebp
  80014a:	c3                   	ret    

0080014b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	57                   	push   %edi
  80014f:	56                   	push   %esi
  800150:	53                   	push   %ebx
  800151:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800154:	be 00 00 00 00       	mov    $0x0,%esi
  800159:	8b 55 08             	mov    0x8(%ebp),%edx
  80015c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80015f:	b8 04 00 00 00       	mov    $0x4,%eax
  800164:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800167:	89 f7                	mov    %esi,%edi
  800169:	cd 30                	int    $0x30
    if (check && ret > 0)
  80016b:	85 c0                	test   %eax,%eax
  80016d:	7f 08                	jg     800177 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80016f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800172:	5b                   	pop    %ebx
  800173:	5e                   	pop    %esi
  800174:	5f                   	pop    %edi
  800175:	5d                   	pop    %ebp
  800176:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	50                   	push   %eax
  80017b:	6a 04                	push   $0x4
  80017d:	68 ca 0f 80 00       	push   $0x800fca
  800182:	6a 24                	push   $0x24
  800184:	68 e7 0f 80 00       	push   $0x800fe7
  800189:	e8 6c 01 00 00       	call   8002fa <_panic>

0080018e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	57                   	push   %edi
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
  800194:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800197:	8b 55 08             	mov    0x8(%ebp),%edx
  80019a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019d:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001a8:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ab:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001ad:	85 c0                	test   %eax,%eax
  8001af:	7f 08                	jg     8001b9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b4:	5b                   	pop    %ebx
  8001b5:	5e                   	pop    %esi
  8001b6:	5f                   	pop    %edi
  8001b7:	5d                   	pop    %ebp
  8001b8:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	50                   	push   %eax
  8001bd:	6a 05                	push   $0x5
  8001bf:	68 ca 0f 80 00       	push   $0x800fca
  8001c4:	6a 24                	push   $0x24
  8001c6:	68 e7 0f 80 00       	push   $0x800fe7
  8001cb:	e8 2a 01 00 00       	call   8002fa <_panic>

008001d0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	57                   	push   %edi
  8001d4:	56                   	push   %esi
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001de:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e4:	b8 06 00 00 00       	mov    $0x6,%eax
  8001e9:	89 df                	mov    %ebx,%edi
  8001eb:	89 de                	mov    %ebx,%esi
  8001ed:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001ef:	85 c0                	test   %eax,%eax
  8001f1:	7f 08                	jg     8001fb <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f6:	5b                   	pop    %ebx
  8001f7:	5e                   	pop    %esi
  8001f8:	5f                   	pop    %edi
  8001f9:	5d                   	pop    %ebp
  8001fa:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	50                   	push   %eax
  8001ff:	6a 06                	push   $0x6
  800201:	68 ca 0f 80 00       	push   $0x800fca
  800206:	6a 24                	push   $0x24
  800208:	68 e7 0f 80 00       	push   $0x800fe7
  80020d:	e8 e8 00 00 00       	call   8002fa <_panic>

00800212 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	57                   	push   %edi
  800216:	56                   	push   %esi
  800217:	53                   	push   %ebx
  800218:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80021b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800220:	8b 55 08             	mov    0x8(%ebp),%edx
  800223:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800226:	b8 08 00 00 00       	mov    $0x8,%eax
  80022b:	89 df                	mov    %ebx,%edi
  80022d:	89 de                	mov    %ebx,%esi
  80022f:	cd 30                	int    $0x30
    if (check && ret > 0)
  800231:	85 c0                	test   %eax,%eax
  800233:	7f 08                	jg     80023d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800235:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800238:	5b                   	pop    %ebx
  800239:	5e                   	pop    %esi
  80023a:	5f                   	pop    %edi
  80023b:	5d                   	pop    %ebp
  80023c:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	50                   	push   %eax
  800241:	6a 08                	push   $0x8
  800243:	68 ca 0f 80 00       	push   $0x800fca
  800248:	6a 24                	push   $0x24
  80024a:	68 e7 0f 80 00       	push   $0x800fe7
  80024f:	e8 a6 00 00 00       	call   8002fa <_panic>

00800254 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	57                   	push   %edi
  800258:	56                   	push   %esi
  800259:	53                   	push   %ebx
  80025a:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80025d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800262:	8b 55 08             	mov    0x8(%ebp),%edx
  800265:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800268:	b8 09 00 00 00       	mov    $0x9,%eax
  80026d:	89 df                	mov    %ebx,%edi
  80026f:	89 de                	mov    %ebx,%esi
  800271:	cd 30                	int    $0x30
    if (check && ret > 0)
  800273:	85 c0                	test   %eax,%eax
  800275:	7f 08                	jg     80027f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800277:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027a:	5b                   	pop    %ebx
  80027b:	5e                   	pop    %esi
  80027c:	5f                   	pop    %edi
  80027d:	5d                   	pop    %ebp
  80027e:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	50                   	push   %eax
  800283:	6a 09                	push   $0x9
  800285:	68 ca 0f 80 00       	push   $0x800fca
  80028a:	6a 24                	push   $0x24
  80028c:	68 e7 0f 80 00       	push   $0x800fe7
  800291:	e8 64 00 00 00       	call   8002fa <_panic>

00800296 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	57                   	push   %edi
  80029a:	56                   	push   %esi
  80029b:	53                   	push   %ebx
    asm volatile("int %1\n"
  80029c:	8b 55 08             	mov    0x8(%ebp),%edx
  80029f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a2:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002a7:	be 00 00 00 00       	mov    $0x0,%esi
  8002ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002af:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002b2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002b4:	5b                   	pop    %ebx
  8002b5:	5e                   	pop    %esi
  8002b6:	5f                   	pop    %edi
  8002b7:	5d                   	pop    %ebp
  8002b8:	c3                   	ret    

008002b9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	57                   	push   %edi
  8002bd:	56                   	push   %esi
  8002be:	53                   	push   %ebx
  8002bf:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ca:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002cf:	89 cb                	mov    %ecx,%ebx
  8002d1:	89 cf                	mov    %ecx,%edi
  8002d3:	89 ce                	mov    %ecx,%esi
  8002d5:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002d7:	85 c0                	test   %eax,%eax
  8002d9:	7f 08                	jg     8002e3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002de:	5b                   	pop    %ebx
  8002df:	5e                   	pop    %esi
  8002e0:	5f                   	pop    %edi
  8002e1:	5d                   	pop    %ebp
  8002e2:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	50                   	push   %eax
  8002e7:	6a 0c                	push   $0xc
  8002e9:	68 ca 0f 80 00       	push   $0x800fca
  8002ee:	6a 24                	push   $0x24
  8002f0:	68 e7 0f 80 00       	push   $0x800fe7
  8002f5:	e8 00 00 00 00       	call   8002fa <_panic>

008002fa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	56                   	push   %esi
  8002fe:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002ff:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800302:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800308:	e8 00 fe ff ff       	call   80010d <sys_getenvid>
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	ff 75 0c             	pushl  0xc(%ebp)
  800313:	ff 75 08             	pushl  0x8(%ebp)
  800316:	56                   	push   %esi
  800317:	50                   	push   %eax
  800318:	68 f8 0f 80 00       	push   $0x800ff8
  80031d:	e8 b3 00 00 00       	call   8003d5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800322:	83 c4 18             	add    $0x18,%esp
  800325:	53                   	push   %ebx
  800326:	ff 75 10             	pushl  0x10(%ebp)
  800329:	e8 56 00 00 00       	call   800384 <vcprintf>
	cprintf("\n");
  80032e:	c7 04 24 1c 10 80 00 	movl   $0x80101c,(%esp)
  800335:	e8 9b 00 00 00       	call   8003d5 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80033d:	cc                   	int3   
  80033e:	eb fd                	jmp    80033d <_panic+0x43>

00800340 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	53                   	push   %ebx
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80034a:	8b 13                	mov    (%ebx),%edx
  80034c:	8d 42 01             	lea    0x1(%edx),%eax
  80034f:	89 03                	mov    %eax,(%ebx)
  800351:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800354:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800358:	3d ff 00 00 00       	cmp    $0xff,%eax
  80035d:	74 09                	je     800368 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80035f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800366:	c9                   	leave  
  800367:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	68 ff 00 00 00       	push   $0xff
  800370:	8d 43 08             	lea    0x8(%ebx),%eax
  800373:	50                   	push   %eax
  800374:	e8 16 fd ff ff       	call   80008f <sys_cputs>
		b->idx = 0;
  800379:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80037f:	83 c4 10             	add    $0x10,%esp
  800382:	eb db                	jmp    80035f <putch+0x1f>

00800384 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80038d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800394:	00 00 00 
	b.cnt = 0;
  800397:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80039e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003a1:	ff 75 0c             	pushl  0xc(%ebp)
  8003a4:	ff 75 08             	pushl  0x8(%ebp)
  8003a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ad:	50                   	push   %eax
  8003ae:	68 40 03 80 00       	push   $0x800340
  8003b3:	e8 1a 01 00 00       	call   8004d2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003b8:	83 c4 08             	add    $0x8,%esp
  8003bb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003c1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 c2 fc ff ff       	call   80008f <sys_cputs>

	return b.cnt;
}
  8003cd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003d3:	c9                   	leave  
  8003d4:	c3                   	ret    

008003d5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003d5:	55                   	push   %ebp
  8003d6:	89 e5                	mov    %esp,%ebp
  8003d8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003db:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003de:	50                   	push   %eax
  8003df:	ff 75 08             	pushl  0x8(%ebp)
  8003e2:	e8 9d ff ff ff       	call   800384 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003e7:	c9                   	leave  
  8003e8:	c3                   	ret    

008003e9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	57                   	push   %edi
  8003ed:	56                   	push   %esi
  8003ee:	53                   	push   %ebx
  8003ef:	83 ec 1c             	sub    $0x1c,%esp
  8003f2:	89 c7                	mov    %eax,%edi
  8003f4:	89 d6                	mov    %edx,%esi
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800402:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800405:	bb 00 00 00 00       	mov    $0x0,%ebx
  80040a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80040d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800410:	39 d3                	cmp    %edx,%ebx
  800412:	72 05                	jb     800419 <printnum+0x30>
  800414:	39 45 10             	cmp    %eax,0x10(%ebp)
  800417:	77 7a                	ja     800493 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	ff 75 18             	pushl  0x18(%ebp)
  80041f:	8b 45 14             	mov    0x14(%ebp),%eax
  800422:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800425:	53                   	push   %ebx
  800426:	ff 75 10             	pushl  0x10(%ebp)
  800429:	83 ec 08             	sub    $0x8,%esp
  80042c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80042f:	ff 75 e0             	pushl  -0x20(%ebp)
  800432:	ff 75 dc             	pushl  -0x24(%ebp)
  800435:	ff 75 d8             	pushl  -0x28(%ebp)
  800438:	e8 33 09 00 00       	call   800d70 <__udivdi3>
  80043d:	83 c4 18             	add    $0x18,%esp
  800440:	52                   	push   %edx
  800441:	50                   	push   %eax
  800442:	89 f2                	mov    %esi,%edx
  800444:	89 f8                	mov    %edi,%eax
  800446:	e8 9e ff ff ff       	call   8003e9 <printnum>
  80044b:	83 c4 20             	add    $0x20,%esp
  80044e:	eb 13                	jmp    800463 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	56                   	push   %esi
  800454:	ff 75 18             	pushl  0x18(%ebp)
  800457:	ff d7                	call   *%edi
  800459:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80045c:	83 eb 01             	sub    $0x1,%ebx
  80045f:	85 db                	test   %ebx,%ebx
  800461:	7f ed                	jg     800450 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	56                   	push   %esi
  800467:	83 ec 04             	sub    $0x4,%esp
  80046a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046d:	ff 75 e0             	pushl  -0x20(%ebp)
  800470:	ff 75 dc             	pushl  -0x24(%ebp)
  800473:	ff 75 d8             	pushl  -0x28(%ebp)
  800476:	e8 15 0a 00 00       	call   800e90 <__umoddi3>
  80047b:	83 c4 14             	add    $0x14,%esp
  80047e:	0f be 80 1e 10 80 00 	movsbl 0x80101e(%eax),%eax
  800485:	50                   	push   %eax
  800486:	ff d7                	call   *%edi
}
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048e:	5b                   	pop    %ebx
  80048f:	5e                   	pop    %esi
  800490:	5f                   	pop    %edi
  800491:	5d                   	pop    %ebp
  800492:	c3                   	ret    
  800493:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800496:	eb c4                	jmp    80045c <printnum+0x73>

00800498 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80049e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004a2:	8b 10                	mov    (%eax),%edx
  8004a4:	3b 50 04             	cmp    0x4(%eax),%edx
  8004a7:	73 0a                	jae    8004b3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004ac:	89 08                	mov    %ecx,(%eax)
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	88 02                	mov    %al,(%edx)
}
  8004b3:	5d                   	pop    %ebp
  8004b4:	c3                   	ret    

008004b5 <printfmt>:
{
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004bb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004be:	50                   	push   %eax
  8004bf:	ff 75 10             	pushl  0x10(%ebp)
  8004c2:	ff 75 0c             	pushl  0xc(%ebp)
  8004c5:	ff 75 08             	pushl  0x8(%ebp)
  8004c8:	e8 05 00 00 00       	call   8004d2 <vprintfmt>
}
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <vprintfmt>:
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	57                   	push   %edi
  8004d6:	56                   	push   %esi
  8004d7:	53                   	push   %ebx
  8004d8:	83 ec 2c             	sub    $0x2c,%esp
  8004db:	8b 75 08             	mov    0x8(%ebp),%esi
  8004de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004e1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004e4:	e9 00 04 00 00       	jmp    8008e9 <vprintfmt+0x417>
		padc = ' ';
  8004e9:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8004ed:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8004f4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8004fb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800502:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800507:	8d 47 01             	lea    0x1(%edi),%eax
  80050a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80050d:	0f b6 17             	movzbl (%edi),%edx
  800510:	8d 42 dd             	lea    -0x23(%edx),%eax
  800513:	3c 55                	cmp    $0x55,%al
  800515:	0f 87 51 04 00 00    	ja     80096c <vprintfmt+0x49a>
  80051b:	0f b6 c0             	movzbl %al,%eax
  80051e:	ff 24 85 e0 10 80 00 	jmp    *0x8010e0(,%eax,4)
  800525:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800528:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80052c:	eb d9                	jmp    800507 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80052e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800531:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800535:	eb d0                	jmp    800507 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800537:	0f b6 d2             	movzbl %dl,%edx
  80053a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80053d:	b8 00 00 00 00       	mov    $0x0,%eax
  800542:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800545:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800548:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80054c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80054f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800552:	83 f9 09             	cmp    $0x9,%ecx
  800555:	77 55                	ja     8005ac <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800557:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80055a:	eb e9                	jmp    800545 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8d 40 04             	lea    0x4(%eax),%eax
  80056a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80056d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800570:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800574:	79 91                	jns    800507 <vprintfmt+0x35>
				width = precision, precision = -1;
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80057c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800583:	eb 82                	jmp    800507 <vprintfmt+0x35>
  800585:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800588:	85 c0                	test   %eax,%eax
  80058a:	ba 00 00 00 00       	mov    $0x0,%edx
  80058f:	0f 49 d0             	cmovns %eax,%edx
  800592:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800595:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800598:	e9 6a ff ff ff       	jmp    800507 <vprintfmt+0x35>
  80059d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005a0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005a7:	e9 5b ff ff ff       	jmp    800507 <vprintfmt+0x35>
  8005ac:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005af:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b2:	eb bc                	jmp    800570 <vprintfmt+0x9e>
			lflag++;
  8005b4:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005ba:	e9 48 ff ff ff       	jmp    800507 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8d 78 04             	lea    0x4(%eax),%edi
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	53                   	push   %ebx
  8005c9:	ff 30                	pushl  (%eax)
  8005cb:	ff d6                	call   *%esi
			break;
  8005cd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005d0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005d3:	e9 0e 03 00 00       	jmp    8008e6 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8d 78 04             	lea    0x4(%eax),%edi
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	99                   	cltd   
  8005e1:	31 d0                	xor    %edx,%eax
  8005e3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005e5:	83 f8 08             	cmp    $0x8,%eax
  8005e8:	7f 23                	jg     80060d <vprintfmt+0x13b>
  8005ea:	8b 14 85 40 12 80 00 	mov    0x801240(,%eax,4),%edx
  8005f1:	85 d2                	test   %edx,%edx
  8005f3:	74 18                	je     80060d <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8005f5:	52                   	push   %edx
  8005f6:	68 3f 10 80 00       	push   $0x80103f
  8005fb:	53                   	push   %ebx
  8005fc:	56                   	push   %esi
  8005fd:	e8 b3 fe ff ff       	call   8004b5 <printfmt>
  800602:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800605:	89 7d 14             	mov    %edi,0x14(%ebp)
  800608:	e9 d9 02 00 00       	jmp    8008e6 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  80060d:	50                   	push   %eax
  80060e:	68 36 10 80 00       	push   $0x801036
  800613:	53                   	push   %ebx
  800614:	56                   	push   %esi
  800615:	e8 9b fe ff ff       	call   8004b5 <printfmt>
  80061a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80061d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800620:	e9 c1 02 00 00       	jmp    8008e6 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	83 c0 04             	add    $0x4,%eax
  80062b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800633:	85 ff                	test   %edi,%edi
  800635:	b8 2f 10 80 00       	mov    $0x80102f,%eax
  80063a:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80063d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800641:	0f 8e bd 00 00 00    	jle    800704 <vprintfmt+0x232>
  800647:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80064b:	75 0e                	jne    80065b <vprintfmt+0x189>
  80064d:	89 75 08             	mov    %esi,0x8(%ebp)
  800650:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800653:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800656:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800659:	eb 6d                	jmp    8006c8 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80065b:	83 ec 08             	sub    $0x8,%esp
  80065e:	ff 75 d0             	pushl  -0x30(%ebp)
  800661:	57                   	push   %edi
  800662:	e8 ad 03 00 00       	call   800a14 <strnlen>
  800667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80066a:	29 c1                	sub    %eax,%ecx
  80066c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80066f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800672:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800676:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800679:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80067c:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80067e:	eb 0f                	jmp    80068f <vprintfmt+0x1bd>
					putch(padc, putdat);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	53                   	push   %ebx
  800684:	ff 75 e0             	pushl  -0x20(%ebp)
  800687:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800689:	83 ef 01             	sub    $0x1,%edi
  80068c:	83 c4 10             	add    $0x10,%esp
  80068f:	85 ff                	test   %edi,%edi
  800691:	7f ed                	jg     800680 <vprintfmt+0x1ae>
  800693:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800696:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800699:	85 c9                	test   %ecx,%ecx
  80069b:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a0:	0f 49 c1             	cmovns %ecx,%eax
  8006a3:	29 c1                	sub    %eax,%ecx
  8006a5:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006ab:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006ae:	89 cb                	mov    %ecx,%ebx
  8006b0:	eb 16                	jmp    8006c8 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006b6:	75 31                	jne    8006e9 <vprintfmt+0x217>
					putch(ch, putdat);
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	ff 75 0c             	pushl  0xc(%ebp)
  8006be:	50                   	push   %eax
  8006bf:	ff 55 08             	call   *0x8(%ebp)
  8006c2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c5:	83 eb 01             	sub    $0x1,%ebx
  8006c8:	83 c7 01             	add    $0x1,%edi
  8006cb:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006cf:	0f be c2             	movsbl %dl,%eax
  8006d2:	85 c0                	test   %eax,%eax
  8006d4:	74 59                	je     80072f <vprintfmt+0x25d>
  8006d6:	85 f6                	test   %esi,%esi
  8006d8:	78 d8                	js     8006b2 <vprintfmt+0x1e0>
  8006da:	83 ee 01             	sub    $0x1,%esi
  8006dd:	79 d3                	jns    8006b2 <vprintfmt+0x1e0>
  8006df:	89 df                	mov    %ebx,%edi
  8006e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8006e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006e7:	eb 37                	jmp    800720 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e9:	0f be d2             	movsbl %dl,%edx
  8006ec:	83 ea 20             	sub    $0x20,%edx
  8006ef:	83 fa 5e             	cmp    $0x5e,%edx
  8006f2:	76 c4                	jbe    8006b8 <vprintfmt+0x1e6>
					putch('?', putdat);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	ff 75 0c             	pushl  0xc(%ebp)
  8006fa:	6a 3f                	push   $0x3f
  8006fc:	ff 55 08             	call   *0x8(%ebp)
  8006ff:	83 c4 10             	add    $0x10,%esp
  800702:	eb c1                	jmp    8006c5 <vprintfmt+0x1f3>
  800704:	89 75 08             	mov    %esi,0x8(%ebp)
  800707:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80070a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80070d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800710:	eb b6                	jmp    8006c8 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	53                   	push   %ebx
  800716:	6a 20                	push   $0x20
  800718:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80071a:	83 ef 01             	sub    $0x1,%edi
  80071d:	83 c4 10             	add    $0x10,%esp
  800720:	85 ff                	test   %edi,%edi
  800722:	7f ee                	jg     800712 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800724:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
  80072a:	e9 b7 01 00 00       	jmp    8008e6 <vprintfmt+0x414>
  80072f:	89 df                	mov    %ebx,%edi
  800731:	8b 75 08             	mov    0x8(%ebp),%esi
  800734:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800737:	eb e7                	jmp    800720 <vprintfmt+0x24e>
	if (lflag >= 2)
  800739:	83 f9 01             	cmp    $0x1,%ecx
  80073c:	7e 3f                	jle    80077d <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8b 50 04             	mov    0x4(%eax),%edx
  800744:	8b 00                	mov    (%eax),%eax
  800746:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800749:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8d 40 08             	lea    0x8(%eax),%eax
  800752:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800755:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800759:	79 5c                	jns    8007b7 <vprintfmt+0x2e5>
				putch('-', putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	53                   	push   %ebx
  80075f:	6a 2d                	push   $0x2d
  800761:	ff d6                	call   *%esi
				num = -(long long) num;
  800763:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800766:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800769:	f7 da                	neg    %edx
  80076b:	83 d1 00             	adc    $0x0,%ecx
  80076e:	f7 d9                	neg    %ecx
  800770:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800773:	b8 0a 00 00 00       	mov    $0xa,%eax
  800778:	e9 4f 01 00 00       	jmp    8008cc <vprintfmt+0x3fa>
	else if (lflag)
  80077d:	85 c9                	test   %ecx,%ecx
  80077f:	75 1b                	jne    80079c <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800789:	89 c1                	mov    %eax,%ecx
  80078b:	c1 f9 1f             	sar    $0x1f,%ecx
  80078e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8d 40 04             	lea    0x4(%eax),%eax
  800797:	89 45 14             	mov    %eax,0x14(%ebp)
  80079a:	eb b9                	jmp    800755 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a4:	89 c1                	mov    %eax,%ecx
  8007a6:	c1 f9 1f             	sar    $0x1f,%ecx
  8007a9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	8d 40 04             	lea    0x4(%eax),%eax
  8007b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b5:	eb 9e                	jmp    800755 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c2:	e9 05 01 00 00       	jmp    8008cc <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007c7:	83 f9 01             	cmp    $0x1,%ecx
  8007ca:	7e 18                	jle    8007e4 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8b 10                	mov    (%eax),%edx
  8007d1:	8b 48 04             	mov    0x4(%eax),%ecx
  8007d4:	8d 40 08             	lea    0x8(%eax),%eax
  8007d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007df:	e9 e8 00 00 00       	jmp    8008cc <vprintfmt+0x3fa>
	else if (lflag)
  8007e4:	85 c9                	test   %ecx,%ecx
  8007e6:	75 1a                	jne    800802 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8b 10                	mov    (%eax),%edx
  8007ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f2:	8d 40 04             	lea    0x4(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fd:	e9 ca 00 00 00       	jmp    8008cc <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	8b 10                	mov    (%eax),%edx
  800807:	b9 00 00 00 00       	mov    $0x0,%ecx
  80080c:	8d 40 04             	lea    0x4(%eax),%eax
  80080f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800812:	b8 0a 00 00 00       	mov    $0xa,%eax
  800817:	e9 b0 00 00 00       	jmp    8008cc <vprintfmt+0x3fa>
	if (lflag >= 2)
  80081c:	83 f9 01             	cmp    $0x1,%ecx
  80081f:	7e 3c                	jle    80085d <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	8b 50 04             	mov    0x4(%eax),%edx
  800827:	8b 00                	mov    (%eax),%eax
  800829:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8d 40 08             	lea    0x8(%eax),%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800838:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80083c:	79 59                	jns    800897 <vprintfmt+0x3c5>
                putch('-', putdat);
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	53                   	push   %ebx
  800842:	6a 2d                	push   $0x2d
  800844:	ff d6                	call   *%esi
                num = -(long long) num;
  800846:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800849:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80084c:	f7 da                	neg    %edx
  80084e:	83 d1 00             	adc    $0x0,%ecx
  800851:	f7 d9                	neg    %ecx
  800853:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800856:	b8 08 00 00 00       	mov    $0x8,%eax
  80085b:	eb 6f                	jmp    8008cc <vprintfmt+0x3fa>
	else if (lflag)
  80085d:	85 c9                	test   %ecx,%ecx
  80085f:	75 1b                	jne    80087c <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8b 00                	mov    (%eax),%eax
  800866:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800869:	89 c1                	mov    %eax,%ecx
  80086b:	c1 f9 1f             	sar    $0x1f,%ecx
  80086e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8d 40 04             	lea    0x4(%eax),%eax
  800877:	89 45 14             	mov    %eax,0x14(%ebp)
  80087a:	eb bc                	jmp    800838 <vprintfmt+0x366>
		return va_arg(*ap, long);
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800884:	89 c1                	mov    %eax,%ecx
  800886:	c1 f9 1f             	sar    $0x1f,%ecx
  800889:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8d 40 04             	lea    0x4(%eax),%eax
  800892:	89 45 14             	mov    %eax,0x14(%ebp)
  800895:	eb a1                	jmp    800838 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  800897:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80089a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  80089d:	b8 08 00 00 00       	mov    $0x8,%eax
  8008a2:	eb 28                	jmp    8008cc <vprintfmt+0x3fa>
			putch('0', putdat);
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	53                   	push   %ebx
  8008a8:	6a 30                	push   $0x30
  8008aa:	ff d6                	call   *%esi
			putch('x', putdat);
  8008ac:	83 c4 08             	add    $0x8,%esp
  8008af:	53                   	push   %ebx
  8008b0:	6a 78                	push   $0x78
  8008b2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8b 10                	mov    (%eax),%edx
  8008b9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008be:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008c1:	8d 40 04             	lea    0x4(%eax),%eax
  8008c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008cc:	83 ec 0c             	sub    $0xc,%esp
  8008cf:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008d3:	57                   	push   %edi
  8008d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8008d7:	50                   	push   %eax
  8008d8:	51                   	push   %ecx
  8008d9:	52                   	push   %edx
  8008da:	89 da                	mov    %ebx,%edx
  8008dc:	89 f0                	mov    %esi,%eax
  8008de:	e8 06 fb ff ff       	call   8003e9 <printnum>
			break;
  8008e3:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e9:	83 c7 01             	add    $0x1,%edi
  8008ec:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008f0:	83 f8 25             	cmp    $0x25,%eax
  8008f3:	0f 84 f0 fb ff ff    	je     8004e9 <vprintfmt+0x17>
			if (ch == '\0')
  8008f9:	85 c0                	test   %eax,%eax
  8008fb:	0f 84 8b 00 00 00    	je     80098c <vprintfmt+0x4ba>
			putch(ch, putdat);
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	53                   	push   %ebx
  800905:	50                   	push   %eax
  800906:	ff d6                	call   *%esi
  800908:	83 c4 10             	add    $0x10,%esp
  80090b:	eb dc                	jmp    8008e9 <vprintfmt+0x417>
	if (lflag >= 2)
  80090d:	83 f9 01             	cmp    $0x1,%ecx
  800910:	7e 15                	jle    800927 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	8b 10                	mov    (%eax),%edx
  800917:	8b 48 04             	mov    0x4(%eax),%ecx
  80091a:	8d 40 08             	lea    0x8(%eax),%eax
  80091d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800920:	b8 10 00 00 00       	mov    $0x10,%eax
  800925:	eb a5                	jmp    8008cc <vprintfmt+0x3fa>
	else if (lflag)
  800927:	85 c9                	test   %ecx,%ecx
  800929:	75 17                	jne    800942 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	8b 10                	mov    (%eax),%edx
  800930:	b9 00 00 00 00       	mov    $0x0,%ecx
  800935:	8d 40 04             	lea    0x4(%eax),%eax
  800938:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093b:	b8 10 00 00 00       	mov    $0x10,%eax
  800940:	eb 8a                	jmp    8008cc <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	8b 10                	mov    (%eax),%edx
  800947:	b9 00 00 00 00       	mov    $0x0,%ecx
  80094c:	8d 40 04             	lea    0x4(%eax),%eax
  80094f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800952:	b8 10 00 00 00       	mov    $0x10,%eax
  800957:	e9 70 ff ff ff       	jmp    8008cc <vprintfmt+0x3fa>
			putch(ch, putdat);
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	53                   	push   %ebx
  800960:	6a 25                	push   $0x25
  800962:	ff d6                	call   *%esi
			break;
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	e9 7a ff ff ff       	jmp    8008e6 <vprintfmt+0x414>
			putch('%', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	53                   	push   %ebx
  800970:	6a 25                	push   $0x25
  800972:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800974:	83 c4 10             	add    $0x10,%esp
  800977:	89 f8                	mov    %edi,%eax
  800979:	eb 03                	jmp    80097e <vprintfmt+0x4ac>
  80097b:	83 e8 01             	sub    $0x1,%eax
  80097e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800982:	75 f7                	jne    80097b <vprintfmt+0x4a9>
  800984:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800987:	e9 5a ff ff ff       	jmp    8008e6 <vprintfmt+0x414>
}
  80098c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80098f:	5b                   	pop    %ebx
  800990:	5e                   	pop    %esi
  800991:	5f                   	pop    %edi
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 18             	sub    $0x18,%esp
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009a3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009a7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009b1:	85 c0                	test   %eax,%eax
  8009b3:	74 26                	je     8009db <vsnprintf+0x47>
  8009b5:	85 d2                	test   %edx,%edx
  8009b7:	7e 22                	jle    8009db <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b9:	ff 75 14             	pushl  0x14(%ebp)
  8009bc:	ff 75 10             	pushl  0x10(%ebp)
  8009bf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009c2:	50                   	push   %eax
  8009c3:	68 98 04 80 00       	push   $0x800498
  8009c8:	e8 05 fb ff ff       	call   8004d2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
}
  8009d9:	c9                   	leave  
  8009da:	c3                   	ret    
		return -E_INVAL;
  8009db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e0:	eb f7                	jmp    8009d9 <vsnprintf+0x45>

008009e2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009eb:	50                   	push   %eax
  8009ec:	ff 75 10             	pushl  0x10(%ebp)
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	ff 75 08             	pushl  0x8(%ebp)
  8009f5:	e8 9a ff ff ff       	call   800994 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009fa:	c9                   	leave  
  8009fb:	c3                   	ret    

008009fc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a02:	b8 00 00 00 00       	mov    $0x0,%eax
  800a07:	eb 03                	jmp    800a0c <strlen+0x10>
		n++;
  800a09:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a0c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a10:	75 f7                	jne    800a09 <strlen+0xd>
	return n;
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a22:	eb 03                	jmp    800a27 <strnlen+0x13>
		n++;
  800a24:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a27:	39 d0                	cmp    %edx,%eax
  800a29:	74 06                	je     800a31 <strnlen+0x1d>
  800a2b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a2f:	75 f3                	jne    800a24 <strnlen+0x10>
	return n;
}
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    

00800a33 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	53                   	push   %ebx
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a3d:	89 c2                	mov    %eax,%edx
  800a3f:	83 c1 01             	add    $0x1,%ecx
  800a42:	83 c2 01             	add    $0x1,%edx
  800a45:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a49:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a4c:	84 db                	test   %bl,%bl
  800a4e:	75 ef                	jne    800a3f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a50:	5b                   	pop    %ebx
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	53                   	push   %ebx
  800a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a5a:	53                   	push   %ebx
  800a5b:	e8 9c ff ff ff       	call   8009fc <strlen>
  800a60:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a63:	ff 75 0c             	pushl  0xc(%ebp)
  800a66:	01 d8                	add    %ebx,%eax
  800a68:	50                   	push   %eax
  800a69:	e8 c5 ff ff ff       	call   800a33 <strcpy>
	return dst;
}
  800a6e:	89 d8                	mov    %ebx,%eax
  800a70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a73:	c9                   	leave  
  800a74:	c3                   	ret    

00800a75 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	56                   	push   %esi
  800a79:	53                   	push   %ebx
  800a7a:	8b 75 08             	mov    0x8(%ebp),%esi
  800a7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a80:	89 f3                	mov    %esi,%ebx
  800a82:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a85:	89 f2                	mov    %esi,%edx
  800a87:	eb 0f                	jmp    800a98 <strncpy+0x23>
		*dst++ = *src;
  800a89:	83 c2 01             	add    $0x1,%edx
  800a8c:	0f b6 01             	movzbl (%ecx),%eax
  800a8f:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a92:	80 39 01             	cmpb   $0x1,(%ecx)
  800a95:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a98:	39 da                	cmp    %ebx,%edx
  800a9a:	75 ed                	jne    800a89 <strncpy+0x14>
	}
	return ret;
}
  800a9c:	89 f0                	mov    %esi,%eax
  800a9e:	5b                   	pop    %ebx
  800a9f:	5e                   	pop    %esi
  800aa0:	5d                   	pop    %ebp
  800aa1:	c3                   	ret    

00800aa2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	56                   	push   %esi
  800aa6:	53                   	push   %ebx
  800aa7:	8b 75 08             	mov    0x8(%ebp),%esi
  800aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ab0:	89 f0                	mov    %esi,%eax
  800ab2:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ab6:	85 c9                	test   %ecx,%ecx
  800ab8:	75 0b                	jne    800ac5 <strlcpy+0x23>
  800aba:	eb 17                	jmp    800ad3 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800abc:	83 c2 01             	add    $0x1,%edx
  800abf:	83 c0 01             	add    $0x1,%eax
  800ac2:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ac5:	39 d8                	cmp    %ebx,%eax
  800ac7:	74 07                	je     800ad0 <strlcpy+0x2e>
  800ac9:	0f b6 0a             	movzbl (%edx),%ecx
  800acc:	84 c9                	test   %cl,%cl
  800ace:	75 ec                	jne    800abc <strlcpy+0x1a>
		*dst = '\0';
  800ad0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad3:	29 f0                	sub    %esi,%eax
}
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800adf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ae2:	eb 06                	jmp    800aea <strcmp+0x11>
		p++, q++;
  800ae4:	83 c1 01             	add    $0x1,%ecx
  800ae7:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800aea:	0f b6 01             	movzbl (%ecx),%eax
  800aed:	84 c0                	test   %al,%al
  800aef:	74 04                	je     800af5 <strcmp+0x1c>
  800af1:	3a 02                	cmp    (%edx),%al
  800af3:	74 ef                	je     800ae4 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af5:	0f b6 c0             	movzbl %al,%eax
  800af8:	0f b6 12             	movzbl (%edx),%edx
  800afb:	29 d0                	sub    %edx,%eax
}
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	53                   	push   %ebx
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	89 c3                	mov    %eax,%ebx
  800b0b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b0e:	eb 06                	jmp    800b16 <strncmp+0x17>
		n--, p++, q++;
  800b10:	83 c0 01             	add    $0x1,%eax
  800b13:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b16:	39 d8                	cmp    %ebx,%eax
  800b18:	74 16                	je     800b30 <strncmp+0x31>
  800b1a:	0f b6 08             	movzbl (%eax),%ecx
  800b1d:	84 c9                	test   %cl,%cl
  800b1f:	74 04                	je     800b25 <strncmp+0x26>
  800b21:	3a 0a                	cmp    (%edx),%cl
  800b23:	74 eb                	je     800b10 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b25:	0f b6 00             	movzbl (%eax),%eax
  800b28:	0f b6 12             	movzbl (%edx),%edx
  800b2b:	29 d0                	sub    %edx,%eax
}
  800b2d:	5b                   	pop    %ebx
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    
		return 0;
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	eb f6                	jmp    800b2d <strncmp+0x2e>

00800b37 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b41:	0f b6 10             	movzbl (%eax),%edx
  800b44:	84 d2                	test   %dl,%dl
  800b46:	74 09                	je     800b51 <strchr+0x1a>
		if (*s == c)
  800b48:	38 ca                	cmp    %cl,%dl
  800b4a:	74 0a                	je     800b56 <strchr+0x1f>
	for (; *s; s++)
  800b4c:	83 c0 01             	add    $0x1,%eax
  800b4f:	eb f0                	jmp    800b41 <strchr+0xa>
			return (char *) s;
	return 0;
  800b51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b62:	eb 03                	jmp    800b67 <strfind+0xf>
  800b64:	83 c0 01             	add    $0x1,%eax
  800b67:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b6a:	38 ca                	cmp    %cl,%dl
  800b6c:	74 04                	je     800b72 <strfind+0x1a>
  800b6e:	84 d2                	test   %dl,%dl
  800b70:	75 f2                	jne    800b64 <strfind+0xc>
			break;
	return (char *) s;
}
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
  800b7a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b80:	85 c9                	test   %ecx,%ecx
  800b82:	74 13                	je     800b97 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b84:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b8a:	75 05                	jne    800b91 <memset+0x1d>
  800b8c:	f6 c1 03             	test   $0x3,%cl
  800b8f:	74 0d                	je     800b9e <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	fc                   	cld    
  800b95:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b97:	89 f8                	mov    %edi,%eax
  800b99:	5b                   	pop    %ebx
  800b9a:	5e                   	pop    %esi
  800b9b:	5f                   	pop    %edi
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    
		c &= 0xFF;
  800b9e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ba2:	89 d3                	mov    %edx,%ebx
  800ba4:	c1 e3 08             	shl    $0x8,%ebx
  800ba7:	89 d0                	mov    %edx,%eax
  800ba9:	c1 e0 18             	shl    $0x18,%eax
  800bac:	89 d6                	mov    %edx,%esi
  800bae:	c1 e6 10             	shl    $0x10,%esi
  800bb1:	09 f0                	or     %esi,%eax
  800bb3:	09 c2                	or     %eax,%edx
  800bb5:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bb7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bba:	89 d0                	mov    %edx,%eax
  800bbc:	fc                   	cld    
  800bbd:	f3 ab                	rep stos %eax,%es:(%edi)
  800bbf:	eb d6                	jmp    800b97 <memset+0x23>

00800bc1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	57                   	push   %edi
  800bc5:	56                   	push   %esi
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bcf:	39 c6                	cmp    %eax,%esi
  800bd1:	73 35                	jae    800c08 <memmove+0x47>
  800bd3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bd6:	39 c2                	cmp    %eax,%edx
  800bd8:	76 2e                	jbe    800c08 <memmove+0x47>
		s += n;
		d += n;
  800bda:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bdd:	89 d6                	mov    %edx,%esi
  800bdf:	09 fe                	or     %edi,%esi
  800be1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800be7:	74 0c                	je     800bf5 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800be9:	83 ef 01             	sub    $0x1,%edi
  800bec:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bef:	fd                   	std    
  800bf0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bf2:	fc                   	cld    
  800bf3:	eb 21                	jmp    800c16 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf5:	f6 c1 03             	test   $0x3,%cl
  800bf8:	75 ef                	jne    800be9 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bfa:	83 ef 04             	sub    $0x4,%edi
  800bfd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c00:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c03:	fd                   	std    
  800c04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c06:	eb ea                	jmp    800bf2 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c08:	89 f2                	mov    %esi,%edx
  800c0a:	09 c2                	or     %eax,%edx
  800c0c:	f6 c2 03             	test   $0x3,%dl
  800c0f:	74 09                	je     800c1a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c11:	89 c7                	mov    %eax,%edi
  800c13:	fc                   	cld    
  800c14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c16:	5e                   	pop    %esi
  800c17:	5f                   	pop    %edi
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c1a:	f6 c1 03             	test   $0x3,%cl
  800c1d:	75 f2                	jne    800c11 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c1f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c22:	89 c7                	mov    %eax,%edi
  800c24:	fc                   	cld    
  800c25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c27:	eb ed                	jmp    800c16 <memmove+0x55>

00800c29 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c2c:	ff 75 10             	pushl  0x10(%ebp)
  800c2f:	ff 75 0c             	pushl  0xc(%ebp)
  800c32:	ff 75 08             	pushl  0x8(%ebp)
  800c35:	e8 87 ff ff ff       	call   800bc1 <memmove>
}
  800c3a:	c9                   	leave  
  800c3b:	c3                   	ret    

00800c3c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	56                   	push   %esi
  800c40:	53                   	push   %ebx
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c47:	89 c6                	mov    %eax,%esi
  800c49:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c4c:	39 f0                	cmp    %esi,%eax
  800c4e:	74 1c                	je     800c6c <memcmp+0x30>
		if (*s1 != *s2)
  800c50:	0f b6 08             	movzbl (%eax),%ecx
  800c53:	0f b6 1a             	movzbl (%edx),%ebx
  800c56:	38 d9                	cmp    %bl,%cl
  800c58:	75 08                	jne    800c62 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c5a:	83 c0 01             	add    $0x1,%eax
  800c5d:	83 c2 01             	add    $0x1,%edx
  800c60:	eb ea                	jmp    800c4c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c62:	0f b6 c1             	movzbl %cl,%eax
  800c65:	0f b6 db             	movzbl %bl,%ebx
  800c68:	29 d8                	sub    %ebx,%eax
  800c6a:	eb 05                	jmp    800c71 <memcmp+0x35>
	}

	return 0;
  800c6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c7e:	89 c2                	mov    %eax,%edx
  800c80:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c83:	39 d0                	cmp    %edx,%eax
  800c85:	73 09                	jae    800c90 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c87:	38 08                	cmp    %cl,(%eax)
  800c89:	74 05                	je     800c90 <memfind+0x1b>
	for (; s < ends; s++)
  800c8b:	83 c0 01             	add    $0x1,%eax
  800c8e:	eb f3                	jmp    800c83 <memfind+0xe>
			break;
	return (void *) s;
}
  800c90:	5d                   	pop    %ebp
  800c91:	c3                   	ret    

00800c92 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	57                   	push   %edi
  800c96:	56                   	push   %esi
  800c97:	53                   	push   %ebx
  800c98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c9e:	eb 03                	jmp    800ca3 <strtol+0x11>
		s++;
  800ca0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ca3:	0f b6 01             	movzbl (%ecx),%eax
  800ca6:	3c 20                	cmp    $0x20,%al
  800ca8:	74 f6                	je     800ca0 <strtol+0xe>
  800caa:	3c 09                	cmp    $0x9,%al
  800cac:	74 f2                	je     800ca0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cae:	3c 2b                	cmp    $0x2b,%al
  800cb0:	74 2e                	je     800ce0 <strtol+0x4e>
	int neg = 0;
  800cb2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cb7:	3c 2d                	cmp    $0x2d,%al
  800cb9:	74 2f                	je     800cea <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cbb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cc1:	75 05                	jne    800cc8 <strtol+0x36>
  800cc3:	80 39 30             	cmpb   $0x30,(%ecx)
  800cc6:	74 2c                	je     800cf4 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cc8:	85 db                	test   %ebx,%ebx
  800cca:	75 0a                	jne    800cd6 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ccc:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cd1:	80 39 30             	cmpb   $0x30,(%ecx)
  800cd4:	74 28                	je     800cfe <strtol+0x6c>
		base = 10;
  800cd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cde:	eb 50                	jmp    800d30 <strtol+0x9e>
		s++;
  800ce0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ce3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce8:	eb d1                	jmp    800cbb <strtol+0x29>
		s++, neg = 1;
  800cea:	83 c1 01             	add    $0x1,%ecx
  800ced:	bf 01 00 00 00       	mov    $0x1,%edi
  800cf2:	eb c7                	jmp    800cbb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cf8:	74 0e                	je     800d08 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800cfa:	85 db                	test   %ebx,%ebx
  800cfc:	75 d8                	jne    800cd6 <strtol+0x44>
		s++, base = 8;
  800cfe:	83 c1 01             	add    $0x1,%ecx
  800d01:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d06:	eb ce                	jmp    800cd6 <strtol+0x44>
		s += 2, base = 16;
  800d08:	83 c1 02             	add    $0x2,%ecx
  800d0b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d10:	eb c4                	jmp    800cd6 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d12:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d15:	89 f3                	mov    %esi,%ebx
  800d17:	80 fb 19             	cmp    $0x19,%bl
  800d1a:	77 29                	ja     800d45 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d1c:	0f be d2             	movsbl %dl,%edx
  800d1f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d22:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d25:	7d 30                	jge    800d57 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d27:	83 c1 01             	add    $0x1,%ecx
  800d2a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d2e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d30:	0f b6 11             	movzbl (%ecx),%edx
  800d33:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d36:	89 f3                	mov    %esi,%ebx
  800d38:	80 fb 09             	cmp    $0x9,%bl
  800d3b:	77 d5                	ja     800d12 <strtol+0x80>
			dig = *s - '0';
  800d3d:	0f be d2             	movsbl %dl,%edx
  800d40:	83 ea 30             	sub    $0x30,%edx
  800d43:	eb dd                	jmp    800d22 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d45:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d48:	89 f3                	mov    %esi,%ebx
  800d4a:	80 fb 19             	cmp    $0x19,%bl
  800d4d:	77 08                	ja     800d57 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d4f:	0f be d2             	movsbl %dl,%edx
  800d52:	83 ea 37             	sub    $0x37,%edx
  800d55:	eb cb                	jmp    800d22 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d5b:	74 05                	je     800d62 <strtol+0xd0>
		*endptr = (char *) s;
  800d5d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d60:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d62:	89 c2                	mov    %eax,%edx
  800d64:	f7 da                	neg    %edx
  800d66:	85 ff                	test   %edi,%edi
  800d68:	0f 45 c2             	cmovne %edx,%eax
}
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5f                   	pop    %edi
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

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
