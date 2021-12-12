
obj/user/buggyhello2：     文件格式 elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 20 80 00    	pushl  0x802000
  800044:	e8 4d 00 00 00       	call   800096 <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8b 45 08             	mov    0x8(%ebp),%eax
  800057:	8b 55 0c             	mov    0xc(%ebp),%edx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs;
  80005a:	c7 05 08 20 80 00 00 	movl   $0xeec00000,0x802008
  800061:	00 c0 ee 

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800064:	85 c0                	test   %eax,%eax
  800066:	7e 08                	jle    800070 <libmain+0x22>
		binaryname = argv[0];
  800068:	8b 0a                	mov    (%edx),%ecx
  80006a:	89 0d 04 20 80 00    	mov    %ecx,0x802004

	// call user main routine
	umain(argc, argv);
  800070:	83 ec 08             	sub    $0x8,%esp
  800073:	52                   	push   %edx
  800074:	50                   	push   %eax
  800075:	e8 b9 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007a:	e8 05 00 00 00       	call   800084 <exit>
}
  80007f:	83 c4 10             	add    $0x10,%esp
  800082:	c9                   	leave  
  800083:	c3                   	ret    

00800084 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800084:	55                   	push   %ebp
  800085:	89 e5                	mov    %esp,%ebp
  800087:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80008a:	6a 00                	push   $0x0
  80008c:	e8 42 00 00 00       	call   8000d3 <sys_env_destroy>
}
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	c9                   	leave  
  800095:	c3                   	ret    

00800096 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	57                   	push   %edi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
    asm volatile("int %1\n"
  80009c:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a7:	89 c3                	mov    %eax,%ebx
  8000a9:	89 c7                	mov    %eax,%edi
  8000ab:	89 c6                	mov    %eax,%esi
  8000ad:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000af:	5b                   	pop    %ebx
  8000b0:	5e                   	pop    %esi
  8000b1:	5f                   	pop    %edi
  8000b2:	5d                   	pop    %ebp
  8000b3:	c3                   	ret    

008000b4 <sys_cgetc>:

int
sys_cgetc(void) {
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	57                   	push   %edi
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8000bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c4:	89 d1                	mov    %edx,%ecx
  8000c6:	89 d3                	mov    %edx,%ebx
  8000c8:	89 d7                	mov    %edx,%edi
  8000ca:	89 d6                	mov    %edx,%esi
  8000cc:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ce:	5b                   	pop    %ebx
  8000cf:	5e                   	pop    %esi
  8000d0:	5f                   	pop    %edi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e9:	89 cb                	mov    %ecx,%ebx
  8000eb:	89 cf                	mov    %ecx,%edi
  8000ed:	89 ce                	mov    %ecx,%esi
  8000ef:	cd 30                	int    $0x30
    if (check && ret > 0)
  8000f1:	85 c0                	test   %eax,%eax
  8000f3:	7f 08                	jg     8000fd <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f8:	5b                   	pop    %ebx
  8000f9:	5e                   	pop    %esi
  8000fa:	5f                   	pop    %edi
  8000fb:	5d                   	pop    %ebp
  8000fc:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8000fd:	83 ec 0c             	sub    $0xc,%esp
  800100:	50                   	push   %eax
  800101:	6a 03                	push   $0x3
  800103:	68 d8 0f 80 00       	push   $0x800fd8
  800108:	6a 24                	push   $0x24
  80010a:	68 f5 0f 80 00       	push   $0x800ff5
  80010f:	e8 ed 01 00 00       	call   800301 <_panic>

00800114 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800114:	55                   	push   %ebp
  800115:	89 e5                	mov    %esp,%ebp
  800117:	57                   	push   %edi
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
    asm volatile("int %1\n"
  80011a:	ba 00 00 00 00       	mov    $0x0,%edx
  80011f:	b8 02 00 00 00       	mov    $0x2,%eax
  800124:	89 d1                	mov    %edx,%ecx
  800126:	89 d3                	mov    %edx,%ebx
  800128:	89 d7                	mov    %edx,%edi
  80012a:	89 d6                	mov    %edx,%esi
  80012c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5f                   	pop    %edi
  800131:	5d                   	pop    %ebp
  800132:	c3                   	ret    

00800133 <sys_yield>:

void
sys_yield(void)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	57                   	push   %edi
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
    asm volatile("int %1\n"
  800139:	ba 00 00 00 00       	mov    $0x0,%edx
  80013e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800143:	89 d1                	mov    %edx,%ecx
  800145:	89 d3                	mov    %edx,%ebx
  800147:	89 d7                	mov    %edx,%edi
  800149:	89 d6                	mov    %edx,%esi
  80014b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80014d:	5b                   	pop    %ebx
  80014e:	5e                   	pop    %esi
  80014f:	5f                   	pop    %edi
  800150:	5d                   	pop    %ebp
  800151:	c3                   	ret    

00800152 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800152:	55                   	push   %ebp
  800153:	89 e5                	mov    %esp,%ebp
  800155:	57                   	push   %edi
  800156:	56                   	push   %esi
  800157:	53                   	push   %ebx
  800158:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80015b:	be 00 00 00 00       	mov    $0x0,%esi
  800160:	8b 55 08             	mov    0x8(%ebp),%edx
  800163:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800166:	b8 04 00 00 00       	mov    $0x4,%eax
  80016b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80016e:	89 f7                	mov    %esi,%edi
  800170:	cd 30                	int    $0x30
    if (check && ret > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 08                	jg     80017e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800176:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5f                   	pop    %edi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	50                   	push   %eax
  800182:	6a 04                	push   $0x4
  800184:	68 d8 0f 80 00       	push   $0x800fd8
  800189:	6a 24                	push   $0x24
  80018b:	68 f5 0f 80 00       	push   $0x800ff5
  800190:	e8 6c 01 00 00       	call   800301 <_panic>

00800195 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	57                   	push   %edi
  800199:	56                   	push   %esi
  80019a:	53                   	push   %ebx
  80019b:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80019e:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a4:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ac:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001af:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b2:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	7f 08                	jg     8001c0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	5f                   	pop    %edi
  8001be:	5d                   	pop    %ebp
  8001bf:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	6a 05                	push   $0x5
  8001c6:	68 d8 0f 80 00       	push   $0x800fd8
  8001cb:	6a 24                	push   $0x24
  8001cd:	68 f5 0f 80 00       	push   $0x800ff5
  8001d2:	e8 2a 01 00 00       	call   800301 <_panic>

008001d7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	57                   	push   %edi
  8001db:	56                   	push   %esi
  8001dc:	53                   	push   %ebx
  8001dd:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001eb:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f0:	89 df                	mov    %ebx,%edi
  8001f2:	89 de                	mov    %ebx,%esi
  8001f4:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001f6:	85 c0                	test   %eax,%eax
  8001f8:	7f 08                	jg     800202 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fd:	5b                   	pop    %ebx
  8001fe:	5e                   	pop    %esi
  8001ff:	5f                   	pop    %edi
  800200:	5d                   	pop    %ebp
  800201:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	6a 06                	push   $0x6
  800208:	68 d8 0f 80 00       	push   $0x800fd8
  80020d:	6a 24                	push   $0x24
  80020f:	68 f5 0f 80 00       	push   $0x800ff5
  800214:	e8 e8 00 00 00       	call   800301 <_panic>

00800219 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	57                   	push   %edi
  80021d:	56                   	push   %esi
  80021e:	53                   	push   %ebx
  80021f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800222:	bb 00 00 00 00       	mov    $0x0,%ebx
  800227:	8b 55 08             	mov    0x8(%ebp),%edx
  80022a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80022d:	b8 08 00 00 00       	mov    $0x8,%eax
  800232:	89 df                	mov    %ebx,%edi
  800234:	89 de                	mov    %ebx,%esi
  800236:	cd 30                	int    $0x30
    if (check && ret > 0)
  800238:	85 c0                	test   %eax,%eax
  80023a:	7f 08                	jg     800244 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80023c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023f:	5b                   	pop    %ebx
  800240:	5e                   	pop    %esi
  800241:	5f                   	pop    %edi
  800242:	5d                   	pop    %ebp
  800243:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	50                   	push   %eax
  800248:	6a 08                	push   $0x8
  80024a:	68 d8 0f 80 00       	push   $0x800fd8
  80024f:	6a 24                	push   $0x24
  800251:	68 f5 0f 80 00       	push   $0x800ff5
  800256:	e8 a6 00 00 00       	call   800301 <_panic>

0080025b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	57                   	push   %edi
  80025f:	56                   	push   %esi
  800260:	53                   	push   %ebx
  800261:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800264:	bb 00 00 00 00       	mov    $0x0,%ebx
  800269:	8b 55 08             	mov    0x8(%ebp),%edx
  80026c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026f:	b8 09 00 00 00       	mov    $0x9,%eax
  800274:	89 df                	mov    %ebx,%edi
  800276:	89 de                	mov    %ebx,%esi
  800278:	cd 30                	int    $0x30
    if (check && ret > 0)
  80027a:	85 c0                	test   %eax,%eax
  80027c:	7f 08                	jg     800286 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80027e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800281:	5b                   	pop    %ebx
  800282:	5e                   	pop    %esi
  800283:	5f                   	pop    %edi
  800284:	5d                   	pop    %ebp
  800285:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	6a 09                	push   $0x9
  80028c:	68 d8 0f 80 00       	push   $0x800fd8
  800291:	6a 24                	push   $0x24
  800293:	68 f5 0f 80 00       	push   $0x800ff5
  800298:	e8 64 00 00 00       	call   800301 <_panic>

0080029d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	57                   	push   %edi
  8002a1:	56                   	push   %esi
  8002a2:	53                   	push   %ebx
    asm volatile("int %1\n"
  8002a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a9:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002ae:	be 00 00 00 00       	mov    $0x0,%esi
  8002b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002b6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002b9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002bb:	5b                   	pop    %ebx
  8002bc:	5e                   	pop    %esi
  8002bd:	5f                   	pop    %edi
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    

008002c0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	57                   	push   %edi
  8002c4:	56                   	push   %esi
  8002c5:	53                   	push   %ebx
  8002c6:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002d6:	89 cb                	mov    %ecx,%ebx
  8002d8:	89 cf                	mov    %ecx,%edi
  8002da:	89 ce                	mov    %ecx,%esi
  8002dc:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002de:	85 c0                	test   %eax,%eax
  8002e0:	7f 08                	jg     8002ea <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e5:	5b                   	pop    %ebx
  8002e6:	5e                   	pop    %esi
  8002e7:	5f                   	pop    %edi
  8002e8:	5d                   	pop    %ebp
  8002e9:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	50                   	push   %eax
  8002ee:	6a 0c                	push   $0xc
  8002f0:	68 d8 0f 80 00       	push   $0x800fd8
  8002f5:	6a 24                	push   $0x24
  8002f7:	68 f5 0f 80 00       	push   $0x800ff5
  8002fc:	e8 00 00 00 00       	call   800301 <_panic>

00800301 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	56                   	push   %esi
  800305:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800306:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800309:	8b 35 04 20 80 00    	mov    0x802004,%esi
  80030f:	e8 00 fe ff ff       	call   800114 <sys_getenvid>
  800314:	83 ec 0c             	sub    $0xc,%esp
  800317:	ff 75 0c             	pushl  0xc(%ebp)
  80031a:	ff 75 08             	pushl  0x8(%ebp)
  80031d:	56                   	push   %esi
  80031e:	50                   	push   %eax
  80031f:	68 04 10 80 00       	push   $0x801004
  800324:	e8 b3 00 00 00       	call   8003dc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800329:	83 c4 18             	add    $0x18,%esp
  80032c:	53                   	push   %ebx
  80032d:	ff 75 10             	pushl  0x10(%ebp)
  800330:	e8 56 00 00 00       	call   80038b <vcprintf>
	cprintf("\n");
  800335:	c7 04 24 cc 0f 80 00 	movl   $0x800fcc,(%esp)
  80033c:	e8 9b 00 00 00       	call   8003dc <cprintf>
  800341:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800344:	cc                   	int3   
  800345:	eb fd                	jmp    800344 <_panic+0x43>

00800347 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	53                   	push   %ebx
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800351:	8b 13                	mov    (%ebx),%edx
  800353:	8d 42 01             	lea    0x1(%edx),%eax
  800356:	89 03                	mov    %eax,(%ebx)
  800358:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80035b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80035f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800364:	74 09                	je     80036f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800366:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80036a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80036d:	c9                   	leave  
  80036e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80036f:	83 ec 08             	sub    $0x8,%esp
  800372:	68 ff 00 00 00       	push   $0xff
  800377:	8d 43 08             	lea    0x8(%ebx),%eax
  80037a:	50                   	push   %eax
  80037b:	e8 16 fd ff ff       	call   800096 <sys_cputs>
		b->idx = 0;
  800380:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	eb db                	jmp    800366 <putch+0x1f>

0080038b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800394:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80039b:	00 00 00 
	b.cnt = 0;
  80039e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003a5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003a8:	ff 75 0c             	pushl  0xc(%ebp)
  8003ab:	ff 75 08             	pushl  0x8(%ebp)
  8003ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003b4:	50                   	push   %eax
  8003b5:	68 47 03 80 00       	push   $0x800347
  8003ba:	e8 1a 01 00 00       	call   8004d9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003bf:	83 c4 08             	add    $0x8,%esp
  8003c2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003c8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003ce:	50                   	push   %eax
  8003cf:	e8 c2 fc ff ff       	call   800096 <sys_cputs>

	return b.cnt;
}
  8003d4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003da:	c9                   	leave  
  8003db:	c3                   	ret    

008003dc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003e2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003e5:	50                   	push   %eax
  8003e6:	ff 75 08             	pushl  0x8(%ebp)
  8003e9:	e8 9d ff ff ff       	call   80038b <vcprintf>
	va_end(ap);

	return cnt;
}
  8003ee:	c9                   	leave  
  8003ef:	c3                   	ret    

008003f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	57                   	push   %edi
  8003f4:	56                   	push   %esi
  8003f5:	53                   	push   %ebx
  8003f6:	83 ec 1c             	sub    $0x1c,%esp
  8003f9:	89 c7                	mov    %eax,%edi
  8003fb:	89 d6                	mov    %edx,%esi
  8003fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800400:	8b 55 0c             	mov    0xc(%ebp),%edx
  800403:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800406:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  800409:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80040c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800411:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800414:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800417:	39 d3                	cmp    %edx,%ebx
  800419:	72 05                	jb     800420 <printnum+0x30>
  80041b:	39 45 10             	cmp    %eax,0x10(%ebp)
  80041e:	77 7a                	ja     80049a <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800420:	83 ec 0c             	sub    $0xc,%esp
  800423:	ff 75 18             	pushl  0x18(%ebp)
  800426:	8b 45 14             	mov    0x14(%ebp),%eax
  800429:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80042c:	53                   	push   %ebx
  80042d:	ff 75 10             	pushl  0x10(%ebp)
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	ff 75 e4             	pushl  -0x1c(%ebp)
  800436:	ff 75 e0             	pushl  -0x20(%ebp)
  800439:	ff 75 dc             	pushl  -0x24(%ebp)
  80043c:	ff 75 d8             	pushl  -0x28(%ebp)
  80043f:	e8 3c 09 00 00       	call   800d80 <__udivdi3>
  800444:	83 c4 18             	add    $0x18,%esp
  800447:	52                   	push   %edx
  800448:	50                   	push   %eax
  800449:	89 f2                	mov    %esi,%edx
  80044b:	89 f8                	mov    %edi,%eax
  80044d:	e8 9e ff ff ff       	call   8003f0 <printnum>
  800452:	83 c4 20             	add    $0x20,%esp
  800455:	eb 13                	jmp    80046a <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	56                   	push   %esi
  80045b:	ff 75 18             	pushl  0x18(%ebp)
  80045e:	ff d7                	call   *%edi
  800460:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800463:	83 eb 01             	sub    $0x1,%ebx
  800466:	85 db                	test   %ebx,%ebx
  800468:	7f ed                	jg     800457 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	56                   	push   %esi
  80046e:	83 ec 04             	sub    $0x4,%esp
  800471:	ff 75 e4             	pushl  -0x1c(%ebp)
  800474:	ff 75 e0             	pushl  -0x20(%ebp)
  800477:	ff 75 dc             	pushl  -0x24(%ebp)
  80047a:	ff 75 d8             	pushl  -0x28(%ebp)
  80047d:	e8 1e 0a 00 00       	call   800ea0 <__umoddi3>
  800482:	83 c4 14             	add    $0x14,%esp
  800485:	0f be 80 28 10 80 00 	movsbl 0x801028(%eax),%eax
  80048c:	50                   	push   %eax
  80048d:	ff d7                	call   *%edi
}
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800495:	5b                   	pop    %ebx
  800496:	5e                   	pop    %esi
  800497:	5f                   	pop    %edi
  800498:	5d                   	pop    %ebp
  800499:	c3                   	ret    
  80049a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80049d:	eb c4                	jmp    800463 <printnum+0x73>

0080049f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80049f:	55                   	push   %ebp
  8004a0:	89 e5                	mov    %esp,%ebp
  8004a2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004a5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004a9:	8b 10                	mov    (%eax),%edx
  8004ab:	3b 50 04             	cmp    0x4(%eax),%edx
  8004ae:	73 0a                	jae    8004ba <sprintputch+0x1b>
		*b->buf++ = ch;
  8004b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004b3:	89 08                	mov    %ecx,(%eax)
  8004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b8:	88 02                	mov    %al,(%edx)
}
  8004ba:	5d                   	pop    %ebp
  8004bb:	c3                   	ret    

008004bc <printfmt>:
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004c2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004c5:	50                   	push   %eax
  8004c6:	ff 75 10             	pushl  0x10(%ebp)
  8004c9:	ff 75 0c             	pushl  0xc(%ebp)
  8004cc:	ff 75 08             	pushl  0x8(%ebp)
  8004cf:	e8 05 00 00 00       	call   8004d9 <vprintfmt>
}
  8004d4:	83 c4 10             	add    $0x10,%esp
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <vprintfmt>:
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	57                   	push   %edi
  8004dd:	56                   	push   %esi
  8004de:	53                   	push   %ebx
  8004df:	83 ec 2c             	sub    $0x2c,%esp
  8004e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004e8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004eb:	e9 00 04 00 00       	jmp    8008f0 <vprintfmt+0x417>
		padc = ' ';
  8004f0:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8004f4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8004fb:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800502:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800509:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80050e:	8d 47 01             	lea    0x1(%edi),%eax
  800511:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800514:	0f b6 17             	movzbl (%edi),%edx
  800517:	8d 42 dd             	lea    -0x23(%edx),%eax
  80051a:	3c 55                	cmp    $0x55,%al
  80051c:	0f 87 51 04 00 00    	ja     800973 <vprintfmt+0x49a>
  800522:	0f b6 c0             	movzbl %al,%eax
  800525:	ff 24 85 e0 10 80 00 	jmp    *0x8010e0(,%eax,4)
  80052c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80052f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800533:	eb d9                	jmp    80050e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800535:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800538:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80053c:	eb d0                	jmp    80050e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80053e:	0f b6 d2             	movzbl %dl,%edx
  800541:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800544:	b8 00 00 00 00       	mov    $0x0,%eax
  800549:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80054c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80054f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800553:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800556:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800559:	83 f9 09             	cmp    $0x9,%ecx
  80055c:	77 55                	ja     8005b3 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80055e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800561:	eb e9                	jmp    80054c <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800563:	8b 45 14             	mov    0x14(%ebp),%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	8d 40 04             	lea    0x4(%eax),%eax
  800571:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800574:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800577:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057b:	79 91                	jns    80050e <vprintfmt+0x35>
				width = precision, precision = -1;
  80057d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800580:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800583:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80058a:	eb 82                	jmp    80050e <vprintfmt+0x35>
  80058c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80058f:	85 c0                	test   %eax,%eax
  800591:	ba 00 00 00 00       	mov    $0x0,%edx
  800596:	0f 49 d0             	cmovns %eax,%edx
  800599:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80059c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80059f:	e9 6a ff ff ff       	jmp    80050e <vprintfmt+0x35>
  8005a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005a7:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005ae:	e9 5b ff ff ff       	jmp    80050e <vprintfmt+0x35>
  8005b3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b9:	eb bc                	jmp    800577 <vprintfmt+0x9e>
			lflag++;
  8005bb:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005c1:	e9 48 ff ff ff       	jmp    80050e <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8d 78 04             	lea    0x4(%eax),%edi
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	53                   	push   %ebx
  8005d0:	ff 30                	pushl  (%eax)
  8005d2:	ff d6                	call   *%esi
			break;
  8005d4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005d7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005da:	e9 0e 03 00 00       	jmp    8008ed <vprintfmt+0x414>
			err = va_arg(ap, int);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 78 04             	lea    0x4(%eax),%edi
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	99                   	cltd   
  8005e8:	31 d0                	xor    %edx,%eax
  8005ea:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005ec:	83 f8 08             	cmp    $0x8,%eax
  8005ef:	7f 23                	jg     800614 <vprintfmt+0x13b>
  8005f1:	8b 14 85 40 12 80 00 	mov    0x801240(,%eax,4),%edx
  8005f8:	85 d2                	test   %edx,%edx
  8005fa:	74 18                	je     800614 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8005fc:	52                   	push   %edx
  8005fd:	68 49 10 80 00       	push   $0x801049
  800602:	53                   	push   %ebx
  800603:	56                   	push   %esi
  800604:	e8 b3 fe ff ff       	call   8004bc <printfmt>
  800609:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80060c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80060f:	e9 d9 02 00 00       	jmp    8008ed <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800614:	50                   	push   %eax
  800615:	68 40 10 80 00       	push   $0x801040
  80061a:	53                   	push   %ebx
  80061b:	56                   	push   %esi
  80061c:	e8 9b fe ff ff       	call   8004bc <printfmt>
  800621:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800624:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800627:	e9 c1 02 00 00       	jmp    8008ed <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	83 c0 04             	add    $0x4,%eax
  800632:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80063a:	85 ff                	test   %edi,%edi
  80063c:	b8 39 10 80 00       	mov    $0x801039,%eax
  800641:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800644:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800648:	0f 8e bd 00 00 00    	jle    80070b <vprintfmt+0x232>
  80064e:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800652:	75 0e                	jne    800662 <vprintfmt+0x189>
  800654:	89 75 08             	mov    %esi,0x8(%ebp)
  800657:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80065a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80065d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800660:	eb 6d                	jmp    8006cf <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	ff 75 d0             	pushl  -0x30(%ebp)
  800668:	57                   	push   %edi
  800669:	e8 ad 03 00 00       	call   800a1b <strnlen>
  80066e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800671:	29 c1                	sub    %eax,%ecx
  800673:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800676:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800679:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80067d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800680:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800683:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800685:	eb 0f                	jmp    800696 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	53                   	push   %ebx
  80068b:	ff 75 e0             	pushl  -0x20(%ebp)
  80068e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800690:	83 ef 01             	sub    $0x1,%edi
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	85 ff                	test   %edi,%edi
  800698:	7f ed                	jg     800687 <vprintfmt+0x1ae>
  80069a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80069d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006a0:	85 c9                	test   %ecx,%ecx
  8006a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a7:	0f 49 c1             	cmovns %ecx,%eax
  8006aa:	29 c1                	sub    %eax,%ecx
  8006ac:	89 75 08             	mov    %esi,0x8(%ebp)
  8006af:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006b2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006b5:	89 cb                	mov    %ecx,%ebx
  8006b7:	eb 16                	jmp    8006cf <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006bd:	75 31                	jne    8006f0 <vprintfmt+0x217>
					putch(ch, putdat);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	50                   	push   %eax
  8006c6:	ff 55 08             	call   *0x8(%ebp)
  8006c9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006cc:	83 eb 01             	sub    $0x1,%ebx
  8006cf:	83 c7 01             	add    $0x1,%edi
  8006d2:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006d6:	0f be c2             	movsbl %dl,%eax
  8006d9:	85 c0                	test   %eax,%eax
  8006db:	74 59                	je     800736 <vprintfmt+0x25d>
  8006dd:	85 f6                	test   %esi,%esi
  8006df:	78 d8                	js     8006b9 <vprintfmt+0x1e0>
  8006e1:	83 ee 01             	sub    $0x1,%esi
  8006e4:	79 d3                	jns    8006b9 <vprintfmt+0x1e0>
  8006e6:	89 df                	mov    %ebx,%edi
  8006e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8006eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006ee:	eb 37                	jmp    800727 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006f0:	0f be d2             	movsbl %dl,%edx
  8006f3:	83 ea 20             	sub    $0x20,%edx
  8006f6:	83 fa 5e             	cmp    $0x5e,%edx
  8006f9:	76 c4                	jbe    8006bf <vprintfmt+0x1e6>
					putch('?', putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	6a 3f                	push   $0x3f
  800703:	ff 55 08             	call   *0x8(%ebp)
  800706:	83 c4 10             	add    $0x10,%esp
  800709:	eb c1                	jmp    8006cc <vprintfmt+0x1f3>
  80070b:	89 75 08             	mov    %esi,0x8(%ebp)
  80070e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800711:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800714:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800717:	eb b6                	jmp    8006cf <vprintfmt+0x1f6>
				putch(' ', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	6a 20                	push   $0x20
  80071f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800721:	83 ef 01             	sub    $0x1,%edi
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	85 ff                	test   %edi,%edi
  800729:	7f ee                	jg     800719 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80072b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
  800731:	e9 b7 01 00 00       	jmp    8008ed <vprintfmt+0x414>
  800736:	89 df                	mov    %ebx,%edi
  800738:	8b 75 08             	mov    0x8(%ebp),%esi
  80073b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80073e:	eb e7                	jmp    800727 <vprintfmt+0x24e>
	if (lflag >= 2)
  800740:	83 f9 01             	cmp    $0x1,%ecx
  800743:	7e 3f                	jle    800784 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8b 50 04             	mov    0x4(%eax),%edx
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800750:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8d 40 08             	lea    0x8(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80075c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800760:	79 5c                	jns    8007be <vprintfmt+0x2e5>
				putch('-', putdat);
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	53                   	push   %ebx
  800766:	6a 2d                	push   $0x2d
  800768:	ff d6                	call   *%esi
				num = -(long long) num;
  80076a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80076d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800770:	f7 da                	neg    %edx
  800772:	83 d1 00             	adc    $0x0,%ecx
  800775:	f7 d9                	neg    %ecx
  800777:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80077a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077f:	e9 4f 01 00 00       	jmp    8008d3 <vprintfmt+0x3fa>
	else if (lflag)
  800784:	85 c9                	test   %ecx,%ecx
  800786:	75 1b                	jne    8007a3 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800790:	89 c1                	mov    %eax,%ecx
  800792:	c1 f9 1f             	sar    $0x1f,%ecx
  800795:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8d 40 04             	lea    0x4(%eax),%eax
  80079e:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a1:	eb b9                	jmp    80075c <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ab:	89 c1                	mov    %eax,%ecx
  8007ad:	c1 f9 1f             	sar    $0x1f,%ecx
  8007b0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	8d 40 04             	lea    0x4(%eax),%eax
  8007b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bc:	eb 9e                	jmp    80075c <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007be:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c9:	e9 05 01 00 00       	jmp    8008d3 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007ce:	83 f9 01             	cmp    $0x1,%ecx
  8007d1:	7e 18                	jle    8007eb <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 10                	mov    (%eax),%edx
  8007d8:	8b 48 04             	mov    0x4(%eax),%ecx
  8007db:	8d 40 08             	lea    0x8(%eax),%eax
  8007de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e6:	e9 e8 00 00 00       	jmp    8008d3 <vprintfmt+0x3fa>
	else if (lflag)
  8007eb:	85 c9                	test   %ecx,%ecx
  8007ed:	75 1a                	jne    800809 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8b 10                	mov    (%eax),%edx
  8007f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f9:	8d 40 04             	lea    0x4(%eax),%eax
  8007fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800804:	e9 ca 00 00 00       	jmp    8008d3 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	8b 10                	mov    (%eax),%edx
  80080e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800813:	8d 40 04             	lea    0x4(%eax),%eax
  800816:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800819:	b8 0a 00 00 00       	mov    $0xa,%eax
  80081e:	e9 b0 00 00 00       	jmp    8008d3 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800823:	83 f9 01             	cmp    $0x1,%ecx
  800826:	7e 3c                	jle    800864 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8b 50 04             	mov    0x4(%eax),%edx
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800833:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8d 40 08             	lea    0x8(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  80083f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800843:	79 59                	jns    80089e <vprintfmt+0x3c5>
                putch('-', putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	53                   	push   %ebx
  800849:	6a 2d                	push   $0x2d
  80084b:	ff d6                	call   *%esi
                num = -(long long) num;
  80084d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800850:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800853:	f7 da                	neg    %edx
  800855:	83 d1 00             	adc    $0x0,%ecx
  800858:	f7 d9                	neg    %ecx
  80085a:	83 c4 10             	add    $0x10,%esp
            base = 8;
  80085d:	b8 08 00 00 00       	mov    $0x8,%eax
  800862:	eb 6f                	jmp    8008d3 <vprintfmt+0x3fa>
	else if (lflag)
  800864:	85 c9                	test   %ecx,%ecx
  800866:	75 1b                	jne    800883 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800870:	89 c1                	mov    %eax,%ecx
  800872:	c1 f9 1f             	sar    $0x1f,%ecx
  800875:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8d 40 04             	lea    0x4(%eax),%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
  800881:	eb bc                	jmp    80083f <vprintfmt+0x366>
		return va_arg(*ap, long);
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8b 00                	mov    (%eax),%eax
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088b:	89 c1                	mov    %eax,%ecx
  80088d:	c1 f9 1f             	sar    $0x1f,%ecx
  800890:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8d 40 04             	lea    0x4(%eax),%eax
  800899:	89 45 14             	mov    %eax,0x14(%ebp)
  80089c:	eb a1                	jmp    80083f <vprintfmt+0x366>
            num = getint(&ap, lflag);
  80089e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8008a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8008a9:	eb 28                	jmp    8008d3 <vprintfmt+0x3fa>
			putch('0', putdat);
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	53                   	push   %ebx
  8008af:	6a 30                	push   $0x30
  8008b1:	ff d6                	call   *%esi
			putch('x', putdat);
  8008b3:	83 c4 08             	add    $0x8,%esp
  8008b6:	53                   	push   %ebx
  8008b7:	6a 78                	push   $0x78
  8008b9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	8b 10                	mov    (%eax),%edx
  8008c0:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008c5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008c8:	8d 40 04             	lea    0x4(%eax),%eax
  8008cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ce:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008da:	57                   	push   %edi
  8008db:	ff 75 e0             	pushl  -0x20(%ebp)
  8008de:	50                   	push   %eax
  8008df:	51                   	push   %ecx
  8008e0:	52                   	push   %edx
  8008e1:	89 da                	mov    %ebx,%edx
  8008e3:	89 f0                	mov    %esi,%eax
  8008e5:	e8 06 fb ff ff       	call   8003f0 <printnum>
			break;
  8008ea:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f0:	83 c7 01             	add    $0x1,%edi
  8008f3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008f7:	83 f8 25             	cmp    $0x25,%eax
  8008fa:	0f 84 f0 fb ff ff    	je     8004f0 <vprintfmt+0x17>
			if (ch == '\0')
  800900:	85 c0                	test   %eax,%eax
  800902:	0f 84 8b 00 00 00    	je     800993 <vprintfmt+0x4ba>
			putch(ch, putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	53                   	push   %ebx
  80090c:	50                   	push   %eax
  80090d:	ff d6                	call   *%esi
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	eb dc                	jmp    8008f0 <vprintfmt+0x417>
	if (lflag >= 2)
  800914:	83 f9 01             	cmp    $0x1,%ecx
  800917:	7e 15                	jle    80092e <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	8b 10                	mov    (%eax),%edx
  80091e:	8b 48 04             	mov    0x4(%eax),%ecx
  800921:	8d 40 08             	lea    0x8(%eax),%eax
  800924:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800927:	b8 10 00 00 00       	mov    $0x10,%eax
  80092c:	eb a5                	jmp    8008d3 <vprintfmt+0x3fa>
	else if (lflag)
  80092e:	85 c9                	test   %ecx,%ecx
  800930:	75 17                	jne    800949 <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800932:	8b 45 14             	mov    0x14(%ebp),%eax
  800935:	8b 10                	mov    (%eax),%edx
  800937:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093c:	8d 40 04             	lea    0x4(%eax),%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800942:	b8 10 00 00 00       	mov    $0x10,%eax
  800947:	eb 8a                	jmp    8008d3 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	8b 10                	mov    (%eax),%edx
  80094e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800953:	8d 40 04             	lea    0x4(%eax),%eax
  800956:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800959:	b8 10 00 00 00       	mov    $0x10,%eax
  80095e:	e9 70 ff ff ff       	jmp    8008d3 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	53                   	push   %ebx
  800967:	6a 25                	push   $0x25
  800969:	ff d6                	call   *%esi
			break;
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	e9 7a ff ff ff       	jmp    8008ed <vprintfmt+0x414>
			putch('%', putdat);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	53                   	push   %ebx
  800977:	6a 25                	push   $0x25
  800979:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80097b:	83 c4 10             	add    $0x10,%esp
  80097e:	89 f8                	mov    %edi,%eax
  800980:	eb 03                	jmp    800985 <vprintfmt+0x4ac>
  800982:	83 e8 01             	sub    $0x1,%eax
  800985:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800989:	75 f7                	jne    800982 <vprintfmt+0x4a9>
  80098b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80098e:	e9 5a ff ff ff       	jmp    8008ed <vprintfmt+0x414>
}
  800993:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800996:	5b                   	pop    %ebx
  800997:	5e                   	pop    %esi
  800998:	5f                   	pop    %edi
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	83 ec 18             	sub    $0x18,%esp
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009aa:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009ae:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	74 26                	je     8009e2 <vsnprintf+0x47>
  8009bc:	85 d2                	test   %edx,%edx
  8009be:	7e 22                	jle    8009e2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009c0:	ff 75 14             	pushl  0x14(%ebp)
  8009c3:	ff 75 10             	pushl  0x10(%ebp)
  8009c6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009c9:	50                   	push   %eax
  8009ca:	68 9f 04 80 00       	push   $0x80049f
  8009cf:	e8 05 fb ff ff       	call   8004d9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
}
  8009e0:	c9                   	leave  
  8009e1:	c3                   	ret    
		return -E_INVAL;
  8009e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e7:	eb f7                	jmp    8009e0 <vsnprintf+0x45>

008009e9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009ef:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009f2:	50                   	push   %eax
  8009f3:	ff 75 10             	pushl  0x10(%ebp)
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	ff 75 08             	pushl  0x8(%ebp)
  8009fc:	e8 9a ff ff ff       	call   80099b <vsnprintf>
	va_end(ap);

	return rc;
}
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a09:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0e:	eb 03                	jmp    800a13 <strlen+0x10>
		n++;
  800a10:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a17:	75 f7                	jne    800a10 <strlen+0xd>
	return n;
}
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a21:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a24:	b8 00 00 00 00       	mov    $0x0,%eax
  800a29:	eb 03                	jmp    800a2e <strnlen+0x13>
		n++;
  800a2b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a2e:	39 d0                	cmp    %edx,%eax
  800a30:	74 06                	je     800a38 <strnlen+0x1d>
  800a32:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a36:	75 f3                	jne    800a2b <strnlen+0x10>
	return n;
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	53                   	push   %ebx
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a44:	89 c2                	mov    %eax,%edx
  800a46:	83 c1 01             	add    $0x1,%ecx
  800a49:	83 c2 01             	add    $0x1,%edx
  800a4c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a50:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a53:	84 db                	test   %bl,%bl
  800a55:	75 ef                	jne    800a46 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a57:	5b                   	pop    %ebx
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	53                   	push   %ebx
  800a5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a61:	53                   	push   %ebx
  800a62:	e8 9c ff ff ff       	call   800a03 <strlen>
  800a67:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	01 d8                	add    %ebx,%eax
  800a6f:	50                   	push   %eax
  800a70:	e8 c5 ff ff ff       	call   800a3a <strcpy>
	return dst;
}
  800a75:	89 d8                	mov    %ebx,%eax
  800a77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	56                   	push   %esi
  800a80:	53                   	push   %ebx
  800a81:	8b 75 08             	mov    0x8(%ebp),%esi
  800a84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a87:	89 f3                	mov    %esi,%ebx
  800a89:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a8c:	89 f2                	mov    %esi,%edx
  800a8e:	eb 0f                	jmp    800a9f <strncpy+0x23>
		*dst++ = *src;
  800a90:	83 c2 01             	add    $0x1,%edx
  800a93:	0f b6 01             	movzbl (%ecx),%eax
  800a96:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a99:	80 39 01             	cmpb   $0x1,(%ecx)
  800a9c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a9f:	39 da                	cmp    %ebx,%edx
  800aa1:	75 ed                	jne    800a90 <strncpy+0x14>
	}
	return ret;
}
  800aa3:	89 f0                	mov    %esi,%eax
  800aa5:	5b                   	pop    %ebx
  800aa6:	5e                   	pop    %esi
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	56                   	push   %esi
  800aad:	53                   	push   %ebx
  800aae:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ab7:	89 f0                	mov    %esi,%eax
  800ab9:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800abd:	85 c9                	test   %ecx,%ecx
  800abf:	75 0b                	jne    800acc <strlcpy+0x23>
  800ac1:	eb 17                	jmp    800ada <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ac3:	83 c2 01             	add    $0x1,%edx
  800ac6:	83 c0 01             	add    $0x1,%eax
  800ac9:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800acc:	39 d8                	cmp    %ebx,%eax
  800ace:	74 07                	je     800ad7 <strlcpy+0x2e>
  800ad0:	0f b6 0a             	movzbl (%edx),%ecx
  800ad3:	84 c9                	test   %cl,%cl
  800ad5:	75 ec                	jne    800ac3 <strlcpy+0x1a>
		*dst = '\0';
  800ad7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ada:	29 f0                	sub    %esi,%eax
}
  800adc:	5b                   	pop    %ebx
  800add:	5e                   	pop    %esi
  800ade:	5d                   	pop    %ebp
  800adf:	c3                   	ret    

00800ae0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ae9:	eb 06                	jmp    800af1 <strcmp+0x11>
		p++, q++;
  800aeb:	83 c1 01             	add    $0x1,%ecx
  800aee:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800af1:	0f b6 01             	movzbl (%ecx),%eax
  800af4:	84 c0                	test   %al,%al
  800af6:	74 04                	je     800afc <strcmp+0x1c>
  800af8:	3a 02                	cmp    (%edx),%al
  800afa:	74 ef                	je     800aeb <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800afc:	0f b6 c0             	movzbl %al,%eax
  800aff:	0f b6 12             	movzbl (%edx),%edx
  800b02:	29 d0                	sub    %edx,%eax
}
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	53                   	push   %ebx
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	89 c3                	mov    %eax,%ebx
  800b12:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b15:	eb 06                	jmp    800b1d <strncmp+0x17>
		n--, p++, q++;
  800b17:	83 c0 01             	add    $0x1,%eax
  800b1a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b1d:	39 d8                	cmp    %ebx,%eax
  800b1f:	74 16                	je     800b37 <strncmp+0x31>
  800b21:	0f b6 08             	movzbl (%eax),%ecx
  800b24:	84 c9                	test   %cl,%cl
  800b26:	74 04                	je     800b2c <strncmp+0x26>
  800b28:	3a 0a                	cmp    (%edx),%cl
  800b2a:	74 eb                	je     800b17 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2c:	0f b6 00             	movzbl (%eax),%eax
  800b2f:	0f b6 12             	movzbl (%edx),%edx
  800b32:	29 d0                	sub    %edx,%eax
}
  800b34:	5b                   	pop    %ebx
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    
		return 0;
  800b37:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3c:	eb f6                	jmp    800b34 <strncmp+0x2e>

00800b3e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b48:	0f b6 10             	movzbl (%eax),%edx
  800b4b:	84 d2                	test   %dl,%dl
  800b4d:	74 09                	je     800b58 <strchr+0x1a>
		if (*s == c)
  800b4f:	38 ca                	cmp    %cl,%dl
  800b51:	74 0a                	je     800b5d <strchr+0x1f>
	for (; *s; s++)
  800b53:	83 c0 01             	add    $0x1,%eax
  800b56:	eb f0                	jmp    800b48 <strchr+0xa>
			return (char *) s;
	return 0;
  800b58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    

00800b5f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b69:	eb 03                	jmp    800b6e <strfind+0xf>
  800b6b:	83 c0 01             	add    $0x1,%eax
  800b6e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b71:	38 ca                	cmp    %cl,%dl
  800b73:	74 04                	je     800b79 <strfind+0x1a>
  800b75:	84 d2                	test   %dl,%dl
  800b77:	75 f2                	jne    800b6b <strfind+0xc>
			break;
	return (char *) s;
}
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	57                   	push   %edi
  800b7f:	56                   	push   %esi
  800b80:	53                   	push   %ebx
  800b81:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b84:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b87:	85 c9                	test   %ecx,%ecx
  800b89:	74 13                	je     800b9e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b8b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b91:	75 05                	jne    800b98 <memset+0x1d>
  800b93:	f6 c1 03             	test   $0x3,%cl
  800b96:	74 0d                	je     800ba5 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9b:	fc                   	cld    
  800b9c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b9e:	89 f8                	mov    %edi,%eax
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    
		c &= 0xFF;
  800ba5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ba9:	89 d3                	mov    %edx,%ebx
  800bab:	c1 e3 08             	shl    $0x8,%ebx
  800bae:	89 d0                	mov    %edx,%eax
  800bb0:	c1 e0 18             	shl    $0x18,%eax
  800bb3:	89 d6                	mov    %edx,%esi
  800bb5:	c1 e6 10             	shl    $0x10,%esi
  800bb8:	09 f0                	or     %esi,%eax
  800bba:	09 c2                	or     %eax,%edx
  800bbc:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bbe:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	fc                   	cld    
  800bc4:	f3 ab                	rep stos %eax,%es:(%edi)
  800bc6:	eb d6                	jmp    800b9e <memset+0x23>

00800bc8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bd6:	39 c6                	cmp    %eax,%esi
  800bd8:	73 35                	jae    800c0f <memmove+0x47>
  800bda:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bdd:	39 c2                	cmp    %eax,%edx
  800bdf:	76 2e                	jbe    800c0f <memmove+0x47>
		s += n;
		d += n;
  800be1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be4:	89 d6                	mov    %edx,%esi
  800be6:	09 fe                	or     %edi,%esi
  800be8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bee:	74 0c                	je     800bfc <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bf0:	83 ef 01             	sub    $0x1,%edi
  800bf3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bf6:	fd                   	std    
  800bf7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bf9:	fc                   	cld    
  800bfa:	eb 21                	jmp    800c1d <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfc:	f6 c1 03             	test   $0x3,%cl
  800bff:	75 ef                	jne    800bf0 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c01:	83 ef 04             	sub    $0x4,%edi
  800c04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c07:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c0a:	fd                   	std    
  800c0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c0d:	eb ea                	jmp    800bf9 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0f:	89 f2                	mov    %esi,%edx
  800c11:	09 c2                	or     %eax,%edx
  800c13:	f6 c2 03             	test   $0x3,%dl
  800c16:	74 09                	je     800c21 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c18:	89 c7                	mov    %eax,%edi
  800c1a:	fc                   	cld    
  800c1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c1d:	5e                   	pop    %esi
  800c1e:	5f                   	pop    %edi
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c21:	f6 c1 03             	test   $0x3,%cl
  800c24:	75 f2                	jne    800c18 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c26:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c29:	89 c7                	mov    %eax,%edi
  800c2b:	fc                   	cld    
  800c2c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2e:	eb ed                	jmp    800c1d <memmove+0x55>

00800c30 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c33:	ff 75 10             	pushl  0x10(%ebp)
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	ff 75 08             	pushl  0x8(%ebp)
  800c3c:	e8 87 ff ff ff       	call   800bc8 <memmove>
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	56                   	push   %esi
  800c47:	53                   	push   %ebx
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4e:	89 c6                	mov    %eax,%esi
  800c50:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c53:	39 f0                	cmp    %esi,%eax
  800c55:	74 1c                	je     800c73 <memcmp+0x30>
		if (*s1 != *s2)
  800c57:	0f b6 08             	movzbl (%eax),%ecx
  800c5a:	0f b6 1a             	movzbl (%edx),%ebx
  800c5d:	38 d9                	cmp    %bl,%cl
  800c5f:	75 08                	jne    800c69 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c61:	83 c0 01             	add    $0x1,%eax
  800c64:	83 c2 01             	add    $0x1,%edx
  800c67:	eb ea                	jmp    800c53 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c69:	0f b6 c1             	movzbl %cl,%eax
  800c6c:	0f b6 db             	movzbl %bl,%ebx
  800c6f:	29 d8                	sub    %ebx,%eax
  800c71:	eb 05                	jmp    800c78 <memcmp+0x35>
	}

	return 0;
  800c73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c78:	5b                   	pop    %ebx
  800c79:	5e                   	pop    %esi
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    

00800c7c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c85:	89 c2                	mov    %eax,%edx
  800c87:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c8a:	39 d0                	cmp    %edx,%eax
  800c8c:	73 09                	jae    800c97 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c8e:	38 08                	cmp    %cl,(%eax)
  800c90:	74 05                	je     800c97 <memfind+0x1b>
	for (; s < ends; s++)
  800c92:	83 c0 01             	add    $0x1,%eax
  800c95:	eb f3                	jmp    800c8a <memfind+0xe>
			break;
	return (void *) s;
}
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	57                   	push   %edi
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
  800c9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca5:	eb 03                	jmp    800caa <strtol+0x11>
		s++;
  800ca7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800caa:	0f b6 01             	movzbl (%ecx),%eax
  800cad:	3c 20                	cmp    $0x20,%al
  800caf:	74 f6                	je     800ca7 <strtol+0xe>
  800cb1:	3c 09                	cmp    $0x9,%al
  800cb3:	74 f2                	je     800ca7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cb5:	3c 2b                	cmp    $0x2b,%al
  800cb7:	74 2e                	je     800ce7 <strtol+0x4e>
	int neg = 0;
  800cb9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cbe:	3c 2d                	cmp    $0x2d,%al
  800cc0:	74 2f                	je     800cf1 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cc8:	75 05                	jne    800ccf <strtol+0x36>
  800cca:	80 39 30             	cmpb   $0x30,(%ecx)
  800ccd:	74 2c                	je     800cfb <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ccf:	85 db                	test   %ebx,%ebx
  800cd1:	75 0a                	jne    800cdd <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cd3:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cd8:	80 39 30             	cmpb   $0x30,(%ecx)
  800cdb:	74 28                	je     800d05 <strtol+0x6c>
		base = 10;
  800cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ce5:	eb 50                	jmp    800d37 <strtol+0x9e>
		s++;
  800ce7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cea:	bf 00 00 00 00       	mov    $0x0,%edi
  800cef:	eb d1                	jmp    800cc2 <strtol+0x29>
		s++, neg = 1;
  800cf1:	83 c1 01             	add    $0x1,%ecx
  800cf4:	bf 01 00 00 00       	mov    $0x1,%edi
  800cf9:	eb c7                	jmp    800cc2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cfb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cff:	74 0e                	je     800d0f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d01:	85 db                	test   %ebx,%ebx
  800d03:	75 d8                	jne    800cdd <strtol+0x44>
		s++, base = 8;
  800d05:	83 c1 01             	add    $0x1,%ecx
  800d08:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d0d:	eb ce                	jmp    800cdd <strtol+0x44>
		s += 2, base = 16;
  800d0f:	83 c1 02             	add    $0x2,%ecx
  800d12:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d17:	eb c4                	jmp    800cdd <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d19:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d1c:	89 f3                	mov    %esi,%ebx
  800d1e:	80 fb 19             	cmp    $0x19,%bl
  800d21:	77 29                	ja     800d4c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d23:	0f be d2             	movsbl %dl,%edx
  800d26:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d29:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d2c:	7d 30                	jge    800d5e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d2e:	83 c1 01             	add    $0x1,%ecx
  800d31:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d35:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d37:	0f b6 11             	movzbl (%ecx),%edx
  800d3a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d3d:	89 f3                	mov    %esi,%ebx
  800d3f:	80 fb 09             	cmp    $0x9,%bl
  800d42:	77 d5                	ja     800d19 <strtol+0x80>
			dig = *s - '0';
  800d44:	0f be d2             	movsbl %dl,%edx
  800d47:	83 ea 30             	sub    $0x30,%edx
  800d4a:	eb dd                	jmp    800d29 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d4c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d4f:	89 f3                	mov    %esi,%ebx
  800d51:	80 fb 19             	cmp    $0x19,%bl
  800d54:	77 08                	ja     800d5e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d56:	0f be d2             	movsbl %dl,%edx
  800d59:	83 ea 37             	sub    $0x37,%edx
  800d5c:	eb cb                	jmp    800d29 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d62:	74 05                	je     800d69 <strtol+0xd0>
		*endptr = (char *) s;
  800d64:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d67:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d69:	89 c2                	mov    %eax,%edx
  800d6b:	f7 da                	neg    %edx
  800d6d:	85 ff                	test   %edi,%edi
  800d6f:	0f 45 c2             	cmovne %edx,%eax
}
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5f                   	pop    %edi
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    
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
