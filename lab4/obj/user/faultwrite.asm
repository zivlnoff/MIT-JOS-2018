
obj/user/faultwrite：     文件格式 elf32-i386


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
	*(unsigned*)0 = 0;
  800036:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
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
  800045:	56                   	push   %esi
  800046:	53                   	push   %ebx
  800047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80004d:	e8 c6 00 00 00       	call   800118 <sys_getenvid>
  800052:	25 ff 03 00 00       	and    $0x3ff,%eax
  800057:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005f:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800064:	85 db                	test   %ebx,%ebx
  800066:	7e 07                	jle    80006f <libmain+0x2d>
		binaryname = argv[0];
  800068:	8b 06                	mov    (%esi),%eax
  80006a:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	e8 ba ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800079:	e8 0a 00 00 00       	call   800088 <exit>
}
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800084:	5b                   	pop    %ebx
  800085:	5e                   	pop    %esi
  800086:	5d                   	pop    %ebp
  800087:	c3                   	ret    

00800088 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800088:	55                   	push   %ebp
  800089:	89 e5                	mov    %esp,%ebp
  80008b:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80008e:	6a 00                	push   $0x0
  800090:	e8 42 00 00 00       	call   8000d7 <sys_env_destroy>
}
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	57                   	push   %edi
  80009e:	56                   	push   %esi
  80009f:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ab:	89 c3                	mov    %eax,%ebx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 c6                	mov    %eax,%esi
  8000b1:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uint32_t) s, len, 0, 0, 0);
}
  8000b3:	5b                   	pop    %ebx
  8000b4:	5e                   	pop    %esi
  8000b5:	5f                   	pop    %edi
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <sys_cgetc>:

int
sys_cgetc(void) {
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	57                   	push   %edi
  8000bc:	56                   	push   %esi
  8000bd:	53                   	push   %ebx
    asm volatile("int %1\n"
  8000be:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c8:	89 d1                	mov    %edx,%ecx
  8000ca:	89 d3                	mov    %edx,%ebx
  8000cc:	89 d7                	mov    %edx,%edi
  8000ce:	89 d6                	mov    %edx,%esi
  8000d0:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d2:	5b                   	pop    %ebx
  8000d3:	5e                   	pop    %esi
  8000d4:	5f                   	pop    %edi
  8000d5:	5d                   	pop    %ebp
  8000d6:	c3                   	ret    

008000d7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	57                   	push   %edi
  8000db:	56                   	push   %esi
  8000dc:	53                   	push   %ebx
  8000dd:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8000e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e8:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ed:	89 cb                	mov    %ecx,%ebx
  8000ef:	89 cf                	mov    %ecx,%edi
  8000f1:	89 ce                	mov    %ecx,%esi
  8000f3:	cd 30                	int    $0x30
    if (check && ret > 0)
  8000f5:	85 c0                	test   %eax,%eax
  8000f7:	7f 08                	jg     800101 <sys_env_destroy+0x2a>
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fc:	5b                   	pop    %ebx
  8000fd:	5e                   	pop    %esi
  8000fe:	5f                   	pop    %edi
  8000ff:	5d                   	pop    %ebp
  800100:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	50                   	push   %eax
  800105:	6a 03                	push   $0x3
  800107:	68 ca 0f 80 00       	push   $0x800fca
  80010c:	6a 24                	push   $0x24
  80010e:	68 e7 0f 80 00       	push   $0x800fe7
  800113:	e8 ed 01 00 00       	call   800305 <_panic>

00800118 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
    asm volatile("int %1\n"
  80011e:	ba 00 00 00 00       	mov    $0x0,%edx
  800123:	b8 02 00 00 00       	mov    $0x2,%eax
  800128:	89 d1                	mov    %edx,%ecx
  80012a:	89 d3                	mov    %edx,%ebx
  80012c:	89 d7                	mov    %edx,%edi
  80012e:	89 d6                	mov    %edx,%esi
  800130:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800132:	5b                   	pop    %ebx
  800133:	5e                   	pop    %esi
  800134:	5f                   	pop    %edi
  800135:	5d                   	pop    %ebp
  800136:	c3                   	ret    

00800137 <sys_yield>:

void
sys_yield(void)
{
  800137:	55                   	push   %ebp
  800138:	89 e5                	mov    %esp,%ebp
  80013a:	57                   	push   %edi
  80013b:	56                   	push   %esi
  80013c:	53                   	push   %ebx
    asm volatile("int %1\n"
  80013d:	ba 00 00 00 00       	mov    $0x0,%edx
  800142:	b8 0a 00 00 00       	mov    $0xa,%eax
  800147:	89 d1                	mov    %edx,%ecx
  800149:	89 d3                	mov    %edx,%ebx
  80014b:	89 d7                	mov    %edx,%edi
  80014d:	89 d6                	mov    %edx,%esi
  80014f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800151:	5b                   	pop    %ebx
  800152:	5e                   	pop    %esi
  800153:	5f                   	pop    %edi
  800154:	5d                   	pop    %ebp
  800155:	c3                   	ret    

00800156 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800156:	55                   	push   %ebp
  800157:	89 e5                	mov    %esp,%ebp
  800159:	57                   	push   %edi
  80015a:	56                   	push   %esi
  80015b:	53                   	push   %ebx
  80015c:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  80015f:	be 00 00 00 00       	mov    $0x0,%esi
  800164:	8b 55 08             	mov    0x8(%ebp),%edx
  800167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016a:	b8 04 00 00 00       	mov    $0x4,%eax
  80016f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800172:	89 f7                	mov    %esi,%edi
  800174:	cd 30                	int    $0x30
    if (check && ret > 0)
  800176:	85 c0                	test   %eax,%eax
  800178:	7f 08                	jg     800182 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017d:	5b                   	pop    %ebx
  80017e:	5e                   	pop    %esi
  80017f:	5f                   	pop    %edi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	6a 04                	push   $0x4
  800188:	68 ca 0f 80 00       	push   $0x800fca
  80018d:	6a 24                	push   $0x24
  80018f:	68 e7 0f 80 00       	push   $0x800fe7
  800194:	e8 6c 01 00 00       	call   800305 <_panic>

00800199 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800199:	55                   	push   %ebp
  80019a:	89 e5                	mov    %esp,%ebp
  80019c:	57                   	push   %edi
  80019d:	56                   	push   %esi
  80019e:	53                   	push   %ebx
  80019f:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b6:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001b8:	85 c0                	test   %eax,%eax
  8001ba:	7f 08                	jg     8001c4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bf:	5b                   	pop    %ebx
  8001c0:	5e                   	pop    %esi
  8001c1:	5f                   	pop    %edi
  8001c2:	5d                   	pop    %ebp
  8001c3:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	50                   	push   %eax
  8001c8:	6a 05                	push   $0x5
  8001ca:	68 ca 0f 80 00       	push   $0x800fca
  8001cf:	6a 24                	push   $0x24
  8001d1:	68 e7 0f 80 00       	push   $0x800fe7
  8001d6:	e8 2a 01 00 00       	call   800305 <_panic>

008001db <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	57                   	push   %edi
  8001df:	56                   	push   %esi
  8001e0:	53                   	push   %ebx
  8001e1:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8001e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f4:	89 df                	mov    %ebx,%edi
  8001f6:	89 de                	mov    %ebx,%esi
  8001f8:	cd 30                	int    $0x30
    if (check && ret > 0)
  8001fa:	85 c0                	test   %eax,%eax
  8001fc:	7f 08                	jg     800206 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800201:	5b                   	pop    %ebx
  800202:	5e                   	pop    %esi
  800203:	5f                   	pop    %edi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	50                   	push   %eax
  80020a:	6a 06                	push   $0x6
  80020c:	68 ca 0f 80 00       	push   $0x800fca
  800211:	6a 24                	push   $0x24
  800213:	68 e7 0f 80 00       	push   $0x800fe7
  800218:	e8 e8 00 00 00       	call   800305 <_panic>

0080021d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	57                   	push   %edi
  800221:	56                   	push   %esi
  800222:	53                   	push   %ebx
  800223:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800226:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022b:	8b 55 08             	mov    0x8(%ebp),%edx
  80022e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800231:	b8 08 00 00 00       	mov    $0x8,%eax
  800236:	89 df                	mov    %ebx,%edi
  800238:	89 de                	mov    %ebx,%esi
  80023a:	cd 30                	int    $0x30
    if (check && ret > 0)
  80023c:	85 c0                	test   %eax,%eax
  80023e:	7f 08                	jg     800248 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800243:	5b                   	pop    %ebx
  800244:	5e                   	pop    %esi
  800245:	5f                   	pop    %edi
  800246:	5d                   	pop    %ebp
  800247:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	50                   	push   %eax
  80024c:	6a 08                	push   $0x8
  80024e:	68 ca 0f 80 00       	push   $0x800fca
  800253:	6a 24                	push   $0x24
  800255:	68 e7 0f 80 00       	push   $0x800fe7
  80025a:	e8 a6 00 00 00       	call   800305 <_panic>

0080025f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	57                   	push   %edi
  800263:	56                   	push   %esi
  800264:	53                   	push   %ebx
  800265:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  800268:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026d:	8b 55 08             	mov    0x8(%ebp),%edx
  800270:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800273:	b8 09 00 00 00       	mov    $0x9,%eax
  800278:	89 df                	mov    %ebx,%edi
  80027a:	89 de                	mov    %ebx,%esi
  80027c:	cd 30                	int    $0x30
    if (check && ret > 0)
  80027e:	85 c0                	test   %eax,%eax
  800280:	7f 08                	jg     80028a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800285:	5b                   	pop    %ebx
  800286:	5e                   	pop    %esi
  800287:	5f                   	pop    %edi
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	50                   	push   %eax
  80028e:	6a 09                	push   $0x9
  800290:	68 ca 0f 80 00       	push   $0x800fca
  800295:	6a 24                	push   $0x24
  800297:	68 e7 0f 80 00       	push   $0x800fe7
  80029c:	e8 64 00 00 00       	call   800305 <_panic>

008002a1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	57                   	push   %edi
  8002a5:	56                   	push   %esi
  8002a6:	53                   	push   %ebx
    asm volatile("int %1\n"
  8002a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ad:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002b2:	be 00 00 00 00       	mov    $0x0,%esi
  8002b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002ba:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002bd:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002bf:	5b                   	pop    %ebx
  8002c0:	5e                   	pop    %esi
  8002c1:	5f                   	pop    %edi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    

008002c4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	57                   	push   %edi
  8002c8:	56                   	push   %esi
  8002c9:	53                   	push   %ebx
  8002ca:	83 ec 0c             	sub    $0xc,%esp
    asm volatile("int %1\n"
  8002cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002da:	89 cb                	mov    %ecx,%ebx
  8002dc:	89 cf                	mov    %ecx,%edi
  8002de:	89 ce                	mov    %ecx,%esi
  8002e0:	cd 30                	int    $0x30
    if (check && ret > 0)
  8002e2:	85 c0                	test   %eax,%eax
  8002e4:	7f 08                	jg     8002ee <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e9:	5b                   	pop    %ebx
  8002ea:	5e                   	pop    %esi
  8002eb:	5f                   	pop    %edi
  8002ec:	5d                   	pop    %ebp
  8002ed:	c3                   	ret    
        panic("syscall %d returned %d (> 0)", num, ret);
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	50                   	push   %eax
  8002f2:	6a 0c                	push   $0xc
  8002f4:	68 ca 0f 80 00       	push   $0x800fca
  8002f9:	6a 24                	push   $0x24
  8002fb:	68 e7 0f 80 00       	push   $0x800fe7
  800300:	e8 00 00 00 00       	call   800305 <_panic>

00800305 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	56                   	push   %esi
  800309:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80030a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80030d:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800313:	e8 00 fe ff ff       	call   800118 <sys_getenvid>
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	ff 75 0c             	pushl  0xc(%ebp)
  80031e:	ff 75 08             	pushl  0x8(%ebp)
  800321:	56                   	push   %esi
  800322:	50                   	push   %eax
  800323:	68 f8 0f 80 00       	push   $0x800ff8
  800328:	e8 b3 00 00 00       	call   8003e0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80032d:	83 c4 18             	add    $0x18,%esp
  800330:	53                   	push   %ebx
  800331:	ff 75 10             	pushl  0x10(%ebp)
  800334:	e8 56 00 00 00       	call   80038f <vcprintf>
	cprintf("\n");
  800339:	c7 04 24 1c 10 80 00 	movl   $0x80101c,(%esp)
  800340:	e8 9b 00 00 00       	call   8003e0 <cprintf>
  800345:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800348:	cc                   	int3   
  800349:	eb fd                	jmp    800348 <_panic+0x43>

0080034b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	53                   	push   %ebx
  80034f:	83 ec 04             	sub    $0x4,%esp
  800352:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800355:	8b 13                	mov    (%ebx),%edx
  800357:	8d 42 01             	lea    0x1(%edx),%eax
  80035a:	89 03                	mov    %eax,(%ebx)
  80035c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80035f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800363:	3d ff 00 00 00       	cmp    $0xff,%eax
  800368:	74 09                	je     800373 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80036a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80036e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800371:	c9                   	leave  
  800372:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800373:	83 ec 08             	sub    $0x8,%esp
  800376:	68 ff 00 00 00       	push   $0xff
  80037b:	8d 43 08             	lea    0x8(%ebx),%eax
  80037e:	50                   	push   %eax
  80037f:	e8 16 fd ff ff       	call   80009a <sys_cputs>
		b->idx = 0;
  800384:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	eb db                	jmp    80036a <putch+0x1f>

0080038f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800398:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80039f:	00 00 00 
	b.cnt = 0;
  8003a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003a9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003b8:	50                   	push   %eax
  8003b9:	68 4b 03 80 00       	push   $0x80034b
  8003be:	e8 1a 01 00 00       	call   8004dd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003c3:	83 c4 08             	add    $0x8,%esp
  8003c6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003cc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003d2:	50                   	push   %eax
  8003d3:	e8 c2 fc ff ff       	call   80009a <sys_cputs>

	return b.cnt;
}
  8003d8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003de:	c9                   	leave  
  8003df:	c3                   	ret    

008003e0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
  8003e3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003e6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003e9:	50                   	push   %eax
  8003ea:	ff 75 08             	pushl  0x8(%ebp)
  8003ed:	e8 9d ff ff ff       	call   80038f <vcprintf>
	va_end(ap);

	return cnt;
}
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	57                   	push   %edi
  8003f8:	56                   	push   %esi
  8003f9:	53                   	push   %ebx
  8003fa:	83 ec 1c             	sub    $0x1c,%esp
  8003fd:	89 c7                	mov    %eax,%edi
  8003ff:	89 d6                	mov    %edx,%esi
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8b 55 0c             	mov    0xc(%ebp),%edx
  800407:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80040a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if ( num>= base) {
  80040d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800410:	bb 00 00 00 00       	mov    $0x0,%ebx
  800415:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800418:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80041b:	39 d3                	cmp    %edx,%ebx
  80041d:	72 05                	jb     800424 <printnum+0x30>
  80041f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800422:	77 7a                	ja     80049e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800424:	83 ec 0c             	sub    $0xc,%esp
  800427:	ff 75 18             	pushl  0x18(%ebp)
  80042a:	8b 45 14             	mov    0x14(%ebp),%eax
  80042d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800430:	53                   	push   %ebx
  800431:	ff 75 10             	pushl  0x10(%ebp)
  800434:	83 ec 08             	sub    $0x8,%esp
  800437:	ff 75 e4             	pushl  -0x1c(%ebp)
  80043a:	ff 75 e0             	pushl  -0x20(%ebp)
  80043d:	ff 75 dc             	pushl  -0x24(%ebp)
  800440:	ff 75 d8             	pushl  -0x28(%ebp)
  800443:	e8 38 09 00 00       	call   800d80 <__udivdi3>
  800448:	83 c4 18             	add    $0x18,%esp
  80044b:	52                   	push   %edx
  80044c:	50                   	push   %eax
  80044d:	89 f2                	mov    %esi,%edx
  80044f:	89 f8                	mov    %edi,%eax
  800451:	e8 9e ff ff ff       	call   8003f4 <printnum>
  800456:	83 c4 20             	add    $0x20,%esp
  800459:	eb 13                	jmp    80046e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	56                   	push   %esi
  80045f:	ff 75 18             	pushl  0x18(%ebp)
  800462:	ff d7                	call   *%edi
  800464:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800467:	83 eb 01             	sub    $0x1,%ebx
  80046a:	85 db                	test   %ebx,%ebx
  80046c:	7f ed                	jg     80045b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	56                   	push   %esi
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	ff 75 e4             	pushl  -0x1c(%ebp)
  800478:	ff 75 e0             	pushl  -0x20(%ebp)
  80047b:	ff 75 dc             	pushl  -0x24(%ebp)
  80047e:	ff 75 d8             	pushl  -0x28(%ebp)
  800481:	e8 1a 0a 00 00       	call   800ea0 <__umoddi3>
  800486:	83 c4 14             	add    $0x14,%esp
  800489:	0f be 80 1e 10 80 00 	movsbl 0x80101e(%eax),%eax
  800490:	50                   	push   %eax
  800491:	ff d7                	call   *%edi
}
  800493:	83 c4 10             	add    $0x10,%esp
  800496:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800499:	5b                   	pop    %ebx
  80049a:	5e                   	pop    %esi
  80049b:	5f                   	pop    %edi
  80049c:	5d                   	pop    %ebp
  80049d:	c3                   	ret    
  80049e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004a1:	eb c4                	jmp    800467 <printnum+0x73>

008004a3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004a9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ad:	8b 10                	mov    (%eax),%edx
  8004af:	3b 50 04             	cmp    0x4(%eax),%edx
  8004b2:	73 0a                	jae    8004be <sprintputch+0x1b>
		*b->buf++ = ch;
  8004b4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004b7:	89 08                	mov    %ecx,(%eax)
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	88 02                	mov    %al,(%edx)
}
  8004be:	5d                   	pop    %ebp
  8004bf:	c3                   	ret    

008004c0 <printfmt>:
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004c6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004c9:	50                   	push   %eax
  8004ca:	ff 75 10             	pushl  0x10(%ebp)
  8004cd:	ff 75 0c             	pushl  0xc(%ebp)
  8004d0:	ff 75 08             	pushl  0x8(%ebp)
  8004d3:	e8 05 00 00 00       	call   8004dd <vprintfmt>
}
  8004d8:	83 c4 10             	add    $0x10,%esp
  8004db:	c9                   	leave  
  8004dc:	c3                   	ret    

008004dd <vprintfmt>:
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	57                   	push   %edi
  8004e1:	56                   	push   %esi
  8004e2:	53                   	push   %ebx
  8004e3:	83 ec 2c             	sub    $0x2c,%esp
  8004e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ec:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004ef:	e9 00 04 00 00       	jmp    8008f4 <vprintfmt+0x417>
		padc = ' ';
  8004f4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8004f8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8004ff:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800506:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80050d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800512:	8d 47 01             	lea    0x1(%edi),%eax
  800515:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800518:	0f b6 17             	movzbl (%edi),%edx
  80051b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80051e:	3c 55                	cmp    $0x55,%al
  800520:	0f 87 51 04 00 00    	ja     800977 <vprintfmt+0x49a>
  800526:	0f b6 c0             	movzbl %al,%eax
  800529:	ff 24 85 e0 10 80 00 	jmp    *0x8010e0(,%eax,4)
  800530:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800533:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800537:	eb d9                	jmp    800512 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800539:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80053c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800540:	eb d0                	jmp    800512 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800542:	0f b6 d2             	movzbl %dl,%edx
  800545:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800548:	b8 00 00 00 00       	mov    $0x0,%eax
  80054d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800550:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800553:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800557:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80055a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80055d:	83 f9 09             	cmp    $0x9,%ecx
  800560:	77 55                	ja     8005b7 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800562:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800565:	eb e9                	jmp    800550 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8d 40 04             	lea    0x4(%eax),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800578:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80057b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057f:	79 91                	jns    800512 <vprintfmt+0x35>
				width = precision, precision = -1;
  800581:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800584:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800587:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80058e:	eb 82                	jmp    800512 <vprintfmt+0x35>
  800590:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800593:	85 c0                	test   %eax,%eax
  800595:	ba 00 00 00 00       	mov    $0x0,%edx
  80059a:	0f 49 d0             	cmovns %eax,%edx
  80059d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005a3:	e9 6a ff ff ff       	jmp    800512 <vprintfmt+0x35>
  8005a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005ab:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005b2:	e9 5b ff ff ff       	jmp    800512 <vprintfmt+0x35>
  8005b7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005bd:	eb bc                	jmp    80057b <vprintfmt+0x9e>
			lflag++;
  8005bf:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005c5:	e9 48 ff ff ff       	jmp    800512 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8d 78 04             	lea    0x4(%eax),%edi
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	53                   	push   %ebx
  8005d4:	ff 30                	pushl  (%eax)
  8005d6:	ff d6                	call   *%esi
			break;
  8005d8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005db:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005de:	e9 0e 03 00 00       	jmp    8008f1 <vprintfmt+0x414>
			err = va_arg(ap, int);
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8d 78 04             	lea    0x4(%eax),%edi
  8005e9:	8b 00                	mov    (%eax),%eax
  8005eb:	99                   	cltd   
  8005ec:	31 d0                	xor    %edx,%eax
  8005ee:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005f0:	83 f8 08             	cmp    $0x8,%eax
  8005f3:	7f 23                	jg     800618 <vprintfmt+0x13b>
  8005f5:	8b 14 85 40 12 80 00 	mov    0x801240(,%eax,4),%edx
  8005fc:	85 d2                	test   %edx,%edx
  8005fe:	74 18                	je     800618 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800600:	52                   	push   %edx
  800601:	68 3f 10 80 00       	push   $0x80103f
  800606:	53                   	push   %ebx
  800607:	56                   	push   %esi
  800608:	e8 b3 fe ff ff       	call   8004c0 <printfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800610:	89 7d 14             	mov    %edi,0x14(%ebp)
  800613:	e9 d9 02 00 00       	jmp    8008f1 <vprintfmt+0x414>
				printfmt(putch, putdat, "error %d", err);
  800618:	50                   	push   %eax
  800619:	68 36 10 80 00       	push   $0x801036
  80061e:	53                   	push   %ebx
  80061f:	56                   	push   %esi
  800620:	e8 9b fe ff ff       	call   8004c0 <printfmt>
  800625:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800628:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80062b:	e9 c1 02 00 00       	jmp    8008f1 <vprintfmt+0x414>
			if ((p = va_arg(ap, char *)) == NULL)
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	83 c0 04             	add    $0x4,%eax
  800636:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80063e:	85 ff                	test   %edi,%edi
  800640:	b8 2f 10 80 00       	mov    $0x80102f,%eax
  800645:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800648:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80064c:	0f 8e bd 00 00 00    	jle    80070f <vprintfmt+0x232>
  800652:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800656:	75 0e                	jne    800666 <vprintfmt+0x189>
  800658:	89 75 08             	mov    %esi,0x8(%ebp)
  80065b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80065e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800661:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800664:	eb 6d                	jmp    8006d3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	ff 75 d0             	pushl  -0x30(%ebp)
  80066c:	57                   	push   %edi
  80066d:	e8 ad 03 00 00       	call   800a1f <strnlen>
  800672:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800675:	29 c1                	sub    %eax,%ecx
  800677:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80067a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80067d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800681:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800684:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800687:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800689:	eb 0f                	jmp    80069a <vprintfmt+0x1bd>
					putch(padc, putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	53                   	push   %ebx
  80068f:	ff 75 e0             	pushl  -0x20(%ebp)
  800692:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800694:	83 ef 01             	sub    $0x1,%edi
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	85 ff                	test   %edi,%edi
  80069c:	7f ed                	jg     80068b <vprintfmt+0x1ae>
  80069e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006a1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006a4:	85 c9                	test   %ecx,%ecx
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ab:	0f 49 c1             	cmovns %ecx,%eax
  8006ae:	29 c1                	sub    %eax,%ecx
  8006b0:	89 75 08             	mov    %esi,0x8(%ebp)
  8006b3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006b6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006b9:	89 cb                	mov    %ecx,%ebx
  8006bb:	eb 16                	jmp    8006d3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006bd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c1:	75 31                	jne    8006f4 <vprintfmt+0x217>
					putch(ch, putdat);
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	ff 75 0c             	pushl  0xc(%ebp)
  8006c9:	50                   	push   %eax
  8006ca:	ff 55 08             	call   *0x8(%ebp)
  8006cd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d0:	83 eb 01             	sub    $0x1,%ebx
  8006d3:	83 c7 01             	add    $0x1,%edi
  8006d6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006da:	0f be c2             	movsbl %dl,%eax
  8006dd:	85 c0                	test   %eax,%eax
  8006df:	74 59                	je     80073a <vprintfmt+0x25d>
  8006e1:	85 f6                	test   %esi,%esi
  8006e3:	78 d8                	js     8006bd <vprintfmt+0x1e0>
  8006e5:	83 ee 01             	sub    $0x1,%esi
  8006e8:	79 d3                	jns    8006bd <vprintfmt+0x1e0>
  8006ea:	89 df                	mov    %ebx,%edi
  8006ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006f2:	eb 37                	jmp    80072b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006f4:	0f be d2             	movsbl %dl,%edx
  8006f7:	83 ea 20             	sub    $0x20,%edx
  8006fa:	83 fa 5e             	cmp    $0x5e,%edx
  8006fd:	76 c4                	jbe    8006c3 <vprintfmt+0x1e6>
					putch('?', putdat);
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	6a 3f                	push   $0x3f
  800707:	ff 55 08             	call   *0x8(%ebp)
  80070a:	83 c4 10             	add    $0x10,%esp
  80070d:	eb c1                	jmp    8006d0 <vprintfmt+0x1f3>
  80070f:	89 75 08             	mov    %esi,0x8(%ebp)
  800712:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800715:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800718:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80071b:	eb b6                	jmp    8006d3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	53                   	push   %ebx
  800721:	6a 20                	push   $0x20
  800723:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800725:	83 ef 01             	sub    $0x1,%edi
  800728:	83 c4 10             	add    $0x10,%esp
  80072b:	85 ff                	test   %edi,%edi
  80072d:	7f ee                	jg     80071d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80072f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
  800735:	e9 b7 01 00 00       	jmp    8008f1 <vprintfmt+0x414>
  80073a:	89 df                	mov    %ebx,%edi
  80073c:	8b 75 08             	mov    0x8(%ebp),%esi
  80073f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800742:	eb e7                	jmp    80072b <vprintfmt+0x24e>
	if (lflag >= 2)
  800744:	83 f9 01             	cmp    $0x1,%ecx
  800747:	7e 3f                	jle    800788 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8b 50 04             	mov    0x4(%eax),%edx
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800754:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8d 40 08             	lea    0x8(%eax),%eax
  80075d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800760:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800764:	79 5c                	jns    8007c2 <vprintfmt+0x2e5>
				putch('-', putdat);
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	53                   	push   %ebx
  80076a:	6a 2d                	push   $0x2d
  80076c:	ff d6                	call   *%esi
				num = -(long long) num;
  80076e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800771:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800774:	f7 da                	neg    %edx
  800776:	83 d1 00             	adc    $0x0,%ecx
  800779:	f7 d9                	neg    %ecx
  80077b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80077e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800783:	e9 4f 01 00 00       	jmp    8008d7 <vprintfmt+0x3fa>
	else if (lflag)
  800788:	85 c9                	test   %ecx,%ecx
  80078a:	75 1b                	jne    8007a7 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800794:	89 c1                	mov    %eax,%ecx
  800796:	c1 f9 1f             	sar    $0x1f,%ecx
  800799:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8d 40 04             	lea    0x4(%eax),%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a5:	eb b9                	jmp    800760 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007af:	89 c1                	mov    %eax,%ecx
  8007b1:	c1 f9 1f             	sar    $0x1f,%ecx
  8007b4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8d 40 04             	lea    0x4(%eax),%eax
  8007bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c0:	eb 9e                	jmp    800760 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007c5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cd:	e9 05 01 00 00       	jmp    8008d7 <vprintfmt+0x3fa>
	if (lflag >= 2)
  8007d2:	83 f9 01             	cmp    $0x1,%ecx
  8007d5:	7e 18                	jle    8007ef <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8b 10                	mov    (%eax),%edx
  8007dc:	8b 48 04             	mov    0x4(%eax),%ecx
  8007df:	8d 40 08             	lea    0x8(%eax),%eax
  8007e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ea:	e9 e8 00 00 00       	jmp    8008d7 <vprintfmt+0x3fa>
	else if (lflag)
  8007ef:	85 c9                	test   %ecx,%ecx
  8007f1:	75 1a                	jne    80080d <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 10                	mov    (%eax),%edx
  8007f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fd:	8d 40 04             	lea    0x4(%eax),%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800803:	b8 0a 00 00 00       	mov    $0xa,%eax
  800808:	e9 ca 00 00 00       	jmp    8008d7 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8b 10                	mov    (%eax),%edx
  800812:	b9 00 00 00 00       	mov    $0x0,%ecx
  800817:	8d 40 04             	lea    0x4(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80081d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800822:	e9 b0 00 00 00       	jmp    8008d7 <vprintfmt+0x3fa>
	if (lflag >= 2)
  800827:	83 f9 01             	cmp    $0x1,%ecx
  80082a:	7e 3c                	jle    800868 <vprintfmt+0x38b>
		return va_arg(*ap, long long);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	8b 50 04             	mov    0x4(%eax),%edx
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800837:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8d 40 08             	lea    0x8(%eax),%eax
  800840:	89 45 14             	mov    %eax,0x14(%ebp)
			if((long long) num < 0){
  800843:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800847:	79 59                	jns    8008a2 <vprintfmt+0x3c5>
                putch('-', putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	53                   	push   %ebx
  80084d:	6a 2d                	push   $0x2d
  80084f:	ff d6                	call   *%esi
                num = -(long long) num;
  800851:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800854:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800857:	f7 da                	neg    %edx
  800859:	83 d1 00             	adc    $0x0,%ecx
  80085c:	f7 d9                	neg    %ecx
  80085e:	83 c4 10             	add    $0x10,%esp
            base = 8;
  800861:	b8 08 00 00 00       	mov    $0x8,%eax
  800866:	eb 6f                	jmp    8008d7 <vprintfmt+0x3fa>
	else if (lflag)
  800868:	85 c9                	test   %ecx,%ecx
  80086a:	75 1b                	jne    800887 <vprintfmt+0x3aa>
		return va_arg(*ap, int);
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800874:	89 c1                	mov    %eax,%ecx
  800876:	c1 f9 1f             	sar    $0x1f,%ecx
  800879:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8d 40 04             	lea    0x4(%eax),%eax
  800882:	89 45 14             	mov    %eax,0x14(%ebp)
  800885:	eb bc                	jmp    800843 <vprintfmt+0x366>
		return va_arg(*ap, long);
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088f:	89 c1                	mov    %eax,%ecx
  800891:	c1 f9 1f             	sar    $0x1f,%ecx
  800894:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8d 40 04             	lea    0x4(%eax),%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a0:	eb a1                	jmp    800843 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  8008a2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008a5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
            base = 8;
  8008a8:	b8 08 00 00 00       	mov    $0x8,%eax
  8008ad:	eb 28                	jmp    8008d7 <vprintfmt+0x3fa>
			putch('0', putdat);
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	53                   	push   %ebx
  8008b3:	6a 30                	push   $0x30
  8008b5:	ff d6                	call   *%esi
			putch('x', putdat);
  8008b7:	83 c4 08             	add    $0x8,%esp
  8008ba:	53                   	push   %ebx
  8008bb:	6a 78                	push   $0x78
  8008bd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	8b 10                	mov    (%eax),%edx
  8008c4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008c9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008cc:	8d 40 04             	lea    0x4(%eax),%eax
  8008cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008d7:	83 ec 0c             	sub    $0xc,%esp
  8008da:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008de:	57                   	push   %edi
  8008df:	ff 75 e0             	pushl  -0x20(%ebp)
  8008e2:	50                   	push   %eax
  8008e3:	51                   	push   %ecx
  8008e4:	52                   	push   %edx
  8008e5:	89 da                	mov    %ebx,%edx
  8008e7:	89 f0                	mov    %esi,%eax
  8008e9:	e8 06 fb ff ff       	call   8003f4 <printnum>
			break;
  8008ee:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f4:	83 c7 01             	add    $0x1,%edi
  8008f7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008fb:	83 f8 25             	cmp    $0x25,%eax
  8008fe:	0f 84 f0 fb ff ff    	je     8004f4 <vprintfmt+0x17>
			if (ch == '\0')
  800904:	85 c0                	test   %eax,%eax
  800906:	0f 84 8b 00 00 00    	je     800997 <vprintfmt+0x4ba>
			putch(ch, putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	53                   	push   %ebx
  800910:	50                   	push   %eax
  800911:	ff d6                	call   *%esi
  800913:	83 c4 10             	add    $0x10,%esp
  800916:	eb dc                	jmp    8008f4 <vprintfmt+0x417>
	if (lflag >= 2)
  800918:	83 f9 01             	cmp    $0x1,%ecx
  80091b:	7e 15                	jle    800932 <vprintfmt+0x455>
		return va_arg(*ap, unsigned long long);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8b 10                	mov    (%eax),%edx
  800922:	8b 48 04             	mov    0x4(%eax),%ecx
  800925:	8d 40 08             	lea    0x8(%eax),%eax
  800928:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092b:	b8 10 00 00 00       	mov    $0x10,%eax
  800930:	eb a5                	jmp    8008d7 <vprintfmt+0x3fa>
	else if (lflag)
  800932:	85 c9                	test   %ecx,%ecx
  800934:	75 17                	jne    80094d <vprintfmt+0x470>
		return va_arg(*ap, unsigned int);
  800936:	8b 45 14             	mov    0x14(%ebp),%eax
  800939:	8b 10                	mov    (%eax),%edx
  80093b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800940:	8d 40 04             	lea    0x4(%eax),%eax
  800943:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800946:	b8 10 00 00 00       	mov    $0x10,%eax
  80094b:	eb 8a                	jmp    8008d7 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	8b 10                	mov    (%eax),%edx
  800952:	b9 00 00 00 00       	mov    $0x0,%ecx
  800957:	8d 40 04             	lea    0x4(%eax),%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80095d:	b8 10 00 00 00       	mov    $0x10,%eax
  800962:	e9 70 ff ff ff       	jmp    8008d7 <vprintfmt+0x3fa>
			putch(ch, putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	53                   	push   %ebx
  80096b:	6a 25                	push   $0x25
  80096d:	ff d6                	call   *%esi
			break;
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	e9 7a ff ff ff       	jmp    8008f1 <vprintfmt+0x414>
			putch('%', putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	53                   	push   %ebx
  80097b:	6a 25                	push   $0x25
  80097d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	89 f8                	mov    %edi,%eax
  800984:	eb 03                	jmp    800989 <vprintfmt+0x4ac>
  800986:	83 e8 01             	sub    $0x1,%eax
  800989:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80098d:	75 f7                	jne    800986 <vprintfmt+0x4a9>
  80098f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800992:	e9 5a ff ff ff       	jmp    8008f1 <vprintfmt+0x414>
}
  800997:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80099a:	5b                   	pop    %ebx
  80099b:	5e                   	pop    %esi
  80099c:	5f                   	pop    %edi
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	83 ec 18             	sub    $0x18,%esp
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ae:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009b2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009bc:	85 c0                	test   %eax,%eax
  8009be:	74 26                	je     8009e6 <vsnprintf+0x47>
  8009c0:	85 d2                	test   %edx,%edx
  8009c2:	7e 22                	jle    8009e6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009c4:	ff 75 14             	pushl  0x14(%ebp)
  8009c7:	ff 75 10             	pushl  0x10(%ebp)
  8009ca:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009cd:	50                   	push   %eax
  8009ce:	68 a3 04 80 00       	push   $0x8004a3
  8009d3:	e8 05 fb ff ff       	call   8004dd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009db:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
}
  8009e4:	c9                   	leave  
  8009e5:	c3                   	ret    
		return -E_INVAL;
  8009e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009eb:	eb f7                	jmp    8009e4 <vsnprintf+0x45>

008009ed <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009f6:	50                   	push   %eax
  8009f7:	ff 75 10             	pushl  0x10(%ebp)
  8009fa:	ff 75 0c             	pushl  0xc(%ebp)
  8009fd:	ff 75 08             	pushl  0x8(%ebp)
  800a00:	e8 9a ff ff ff       	call   80099f <vsnprintf>
	va_end(ap);

	return rc;
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a12:	eb 03                	jmp    800a17 <strlen+0x10>
		n++;
  800a14:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a17:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a1b:	75 f7                	jne    800a14 <strlen+0xd>
	return n;
}
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a25:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a28:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2d:	eb 03                	jmp    800a32 <strnlen+0x13>
		n++;
  800a2f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a32:	39 d0                	cmp    %edx,%eax
  800a34:	74 06                	je     800a3c <strnlen+0x1d>
  800a36:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a3a:	75 f3                	jne    800a2f <strnlen+0x10>
	return n;
}
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    

00800a3e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	53                   	push   %ebx
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a48:	89 c2                	mov    %eax,%edx
  800a4a:	83 c1 01             	add    $0x1,%ecx
  800a4d:	83 c2 01             	add    $0x1,%edx
  800a50:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a54:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a57:	84 db                	test   %bl,%bl
  800a59:	75 ef                	jne    800a4a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a5b:	5b                   	pop    %ebx
  800a5c:	5d                   	pop    %ebp
  800a5d:	c3                   	ret    

00800a5e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	53                   	push   %ebx
  800a62:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a65:	53                   	push   %ebx
  800a66:	e8 9c ff ff ff       	call   800a07 <strlen>
  800a6b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a6e:	ff 75 0c             	pushl  0xc(%ebp)
  800a71:	01 d8                	add    %ebx,%eax
  800a73:	50                   	push   %eax
  800a74:	e8 c5 ff ff ff       	call   800a3e <strcpy>
	return dst;
}
  800a79:	89 d8                	mov    %ebx,%eax
  800a7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7e:	c9                   	leave  
  800a7f:	c3                   	ret    

00800a80 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	56                   	push   %esi
  800a84:	53                   	push   %ebx
  800a85:	8b 75 08             	mov    0x8(%ebp),%esi
  800a88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a8b:	89 f3                	mov    %esi,%ebx
  800a8d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a90:	89 f2                	mov    %esi,%edx
  800a92:	eb 0f                	jmp    800aa3 <strncpy+0x23>
		*dst++ = *src;
  800a94:	83 c2 01             	add    $0x1,%edx
  800a97:	0f b6 01             	movzbl (%ecx),%eax
  800a9a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a9d:	80 39 01             	cmpb   $0x1,(%ecx)
  800aa0:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800aa3:	39 da                	cmp    %ebx,%edx
  800aa5:	75 ed                	jne    800a94 <strncpy+0x14>
	}
	return ret;
}
  800aa7:	89 f0                	mov    %esi,%eax
  800aa9:	5b                   	pop    %ebx
  800aaa:	5e                   	pop    %esi
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	56                   	push   %esi
  800ab1:	53                   	push   %ebx
  800ab2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800abb:	89 f0                	mov    %esi,%eax
  800abd:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac1:	85 c9                	test   %ecx,%ecx
  800ac3:	75 0b                	jne    800ad0 <strlcpy+0x23>
  800ac5:	eb 17                	jmp    800ade <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ac7:	83 c2 01             	add    $0x1,%edx
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ad0:	39 d8                	cmp    %ebx,%eax
  800ad2:	74 07                	je     800adb <strlcpy+0x2e>
  800ad4:	0f b6 0a             	movzbl (%edx),%ecx
  800ad7:	84 c9                	test   %cl,%cl
  800ad9:	75 ec                	jne    800ac7 <strlcpy+0x1a>
		*dst = '\0';
  800adb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ade:	29 f0                	sub    %esi,%eax
}
  800ae0:	5b                   	pop    %ebx
  800ae1:	5e                   	pop    %esi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aea:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aed:	eb 06                	jmp    800af5 <strcmp+0x11>
		p++, q++;
  800aef:	83 c1 01             	add    $0x1,%ecx
  800af2:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800af5:	0f b6 01             	movzbl (%ecx),%eax
  800af8:	84 c0                	test   %al,%al
  800afa:	74 04                	je     800b00 <strcmp+0x1c>
  800afc:	3a 02                	cmp    (%edx),%al
  800afe:	74 ef                	je     800aef <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b00:	0f b6 c0             	movzbl %al,%eax
  800b03:	0f b6 12             	movzbl (%edx),%edx
  800b06:	29 d0                	sub    %edx,%eax
}
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	53                   	push   %ebx
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b14:	89 c3                	mov    %eax,%ebx
  800b16:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b19:	eb 06                	jmp    800b21 <strncmp+0x17>
		n--, p++, q++;
  800b1b:	83 c0 01             	add    $0x1,%eax
  800b1e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b21:	39 d8                	cmp    %ebx,%eax
  800b23:	74 16                	je     800b3b <strncmp+0x31>
  800b25:	0f b6 08             	movzbl (%eax),%ecx
  800b28:	84 c9                	test   %cl,%cl
  800b2a:	74 04                	je     800b30 <strncmp+0x26>
  800b2c:	3a 0a                	cmp    (%edx),%cl
  800b2e:	74 eb                	je     800b1b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b30:	0f b6 00             	movzbl (%eax),%eax
  800b33:	0f b6 12             	movzbl (%edx),%edx
  800b36:	29 d0                	sub    %edx,%eax
}
  800b38:	5b                   	pop    %ebx
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    
		return 0;
  800b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b40:	eb f6                	jmp    800b38 <strncmp+0x2e>

00800b42 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b4c:	0f b6 10             	movzbl (%eax),%edx
  800b4f:	84 d2                	test   %dl,%dl
  800b51:	74 09                	je     800b5c <strchr+0x1a>
		if (*s == c)
  800b53:	38 ca                	cmp    %cl,%dl
  800b55:	74 0a                	je     800b61 <strchr+0x1f>
	for (; *s; s++)
  800b57:	83 c0 01             	add    $0x1,%eax
  800b5a:	eb f0                	jmp    800b4c <strchr+0xa>
			return (char *) s;
	return 0;
  800b5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b6d:	eb 03                	jmp    800b72 <strfind+0xf>
  800b6f:	83 c0 01             	add    $0x1,%eax
  800b72:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b75:	38 ca                	cmp    %cl,%dl
  800b77:	74 04                	je     800b7d <strfind+0x1a>
  800b79:	84 d2                	test   %dl,%dl
  800b7b:	75 f2                	jne    800b6f <strfind+0xc>
			break;
	return (char *) s;
}
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	57                   	push   %edi
  800b83:	56                   	push   %esi
  800b84:	53                   	push   %ebx
  800b85:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b88:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b8b:	85 c9                	test   %ecx,%ecx
  800b8d:	74 13                	je     800ba2 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b8f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b95:	75 05                	jne    800b9c <memset+0x1d>
  800b97:	f6 c1 03             	test   $0x3,%cl
  800b9a:	74 0d                	je     800ba9 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9f:	fc                   	cld    
  800ba0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ba2:	89 f8                	mov    %edi,%eax
  800ba4:	5b                   	pop    %ebx
  800ba5:	5e                   	pop    %esi
  800ba6:	5f                   	pop    %edi
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    
		c &= 0xFF;
  800ba9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bad:	89 d3                	mov    %edx,%ebx
  800baf:	c1 e3 08             	shl    $0x8,%ebx
  800bb2:	89 d0                	mov    %edx,%eax
  800bb4:	c1 e0 18             	shl    $0x18,%eax
  800bb7:	89 d6                	mov    %edx,%esi
  800bb9:	c1 e6 10             	shl    $0x10,%esi
  800bbc:	09 f0                	or     %esi,%eax
  800bbe:	09 c2                	or     %eax,%edx
  800bc0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bc2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bc5:	89 d0                	mov    %edx,%eax
  800bc7:	fc                   	cld    
  800bc8:	f3 ab                	rep stos %eax,%es:(%edi)
  800bca:	eb d6                	jmp    800ba2 <memset+0x23>

00800bcc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bda:	39 c6                	cmp    %eax,%esi
  800bdc:	73 35                	jae    800c13 <memmove+0x47>
  800bde:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800be1:	39 c2                	cmp    %eax,%edx
  800be3:	76 2e                	jbe    800c13 <memmove+0x47>
		s += n;
		d += n;
  800be5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be8:	89 d6                	mov    %edx,%esi
  800bea:	09 fe                	or     %edi,%esi
  800bec:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bf2:	74 0c                	je     800c00 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bf4:	83 ef 01             	sub    $0x1,%edi
  800bf7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bfa:	fd                   	std    
  800bfb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bfd:	fc                   	cld    
  800bfe:	eb 21                	jmp    800c21 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c00:	f6 c1 03             	test   $0x3,%cl
  800c03:	75 ef                	jne    800bf4 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c05:	83 ef 04             	sub    $0x4,%edi
  800c08:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c0b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c0e:	fd                   	std    
  800c0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c11:	eb ea                	jmp    800bfd <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c13:	89 f2                	mov    %esi,%edx
  800c15:	09 c2                	or     %eax,%edx
  800c17:	f6 c2 03             	test   $0x3,%dl
  800c1a:	74 09                	je     800c25 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c1c:	89 c7                	mov    %eax,%edi
  800c1e:	fc                   	cld    
  800c1f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c25:	f6 c1 03             	test   $0x3,%cl
  800c28:	75 f2                	jne    800c1c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c2a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c2d:	89 c7                	mov    %eax,%edi
  800c2f:	fc                   	cld    
  800c30:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c32:	eb ed                	jmp    800c21 <memmove+0x55>

00800c34 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c37:	ff 75 10             	pushl  0x10(%ebp)
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	ff 75 08             	pushl  0x8(%ebp)
  800c40:	e8 87 ff ff ff       	call   800bcc <memmove>
}
  800c45:	c9                   	leave  
  800c46:	c3                   	ret    

00800c47 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	56                   	push   %esi
  800c4b:	53                   	push   %ebx
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c52:	89 c6                	mov    %eax,%esi
  800c54:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c57:	39 f0                	cmp    %esi,%eax
  800c59:	74 1c                	je     800c77 <memcmp+0x30>
		if (*s1 != *s2)
  800c5b:	0f b6 08             	movzbl (%eax),%ecx
  800c5e:	0f b6 1a             	movzbl (%edx),%ebx
  800c61:	38 d9                	cmp    %bl,%cl
  800c63:	75 08                	jne    800c6d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c65:	83 c0 01             	add    $0x1,%eax
  800c68:	83 c2 01             	add    $0x1,%edx
  800c6b:	eb ea                	jmp    800c57 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c6d:	0f b6 c1             	movzbl %cl,%eax
  800c70:	0f b6 db             	movzbl %bl,%ebx
  800c73:	29 d8                	sub    %ebx,%eax
  800c75:	eb 05                	jmp    800c7c <memcmp+0x35>
	}

	return 0;
  800c77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c89:	89 c2                	mov    %eax,%edx
  800c8b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c8e:	39 d0                	cmp    %edx,%eax
  800c90:	73 09                	jae    800c9b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c92:	38 08                	cmp    %cl,(%eax)
  800c94:	74 05                	je     800c9b <memfind+0x1b>
	for (; s < ends; s++)
  800c96:	83 c0 01             	add    $0x1,%eax
  800c99:	eb f3                	jmp    800c8e <memfind+0xe>
			break;
	return (void *) s;
}
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca9:	eb 03                	jmp    800cae <strtol+0x11>
		s++;
  800cab:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cae:	0f b6 01             	movzbl (%ecx),%eax
  800cb1:	3c 20                	cmp    $0x20,%al
  800cb3:	74 f6                	je     800cab <strtol+0xe>
  800cb5:	3c 09                	cmp    $0x9,%al
  800cb7:	74 f2                	je     800cab <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cb9:	3c 2b                	cmp    $0x2b,%al
  800cbb:	74 2e                	je     800ceb <strtol+0x4e>
	int neg = 0;
  800cbd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cc2:	3c 2d                	cmp    $0x2d,%al
  800cc4:	74 2f                	je     800cf5 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ccc:	75 05                	jne    800cd3 <strtol+0x36>
  800cce:	80 39 30             	cmpb   $0x30,(%ecx)
  800cd1:	74 2c                	je     800cff <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cd3:	85 db                	test   %ebx,%ebx
  800cd5:	75 0a                	jne    800ce1 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cd7:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cdc:	80 39 30             	cmpb   $0x30,(%ecx)
  800cdf:	74 28                	je     800d09 <strtol+0x6c>
		base = 10;
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ce9:	eb 50                	jmp    800d3b <strtol+0x9e>
		s++;
  800ceb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cee:	bf 00 00 00 00       	mov    $0x0,%edi
  800cf3:	eb d1                	jmp    800cc6 <strtol+0x29>
		s++, neg = 1;
  800cf5:	83 c1 01             	add    $0x1,%ecx
  800cf8:	bf 01 00 00 00       	mov    $0x1,%edi
  800cfd:	eb c7                	jmp    800cc6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cff:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d03:	74 0e                	je     800d13 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d05:	85 db                	test   %ebx,%ebx
  800d07:	75 d8                	jne    800ce1 <strtol+0x44>
		s++, base = 8;
  800d09:	83 c1 01             	add    $0x1,%ecx
  800d0c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d11:	eb ce                	jmp    800ce1 <strtol+0x44>
		s += 2, base = 16;
  800d13:	83 c1 02             	add    $0x2,%ecx
  800d16:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d1b:	eb c4                	jmp    800ce1 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d1d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d20:	89 f3                	mov    %esi,%ebx
  800d22:	80 fb 19             	cmp    $0x19,%bl
  800d25:	77 29                	ja     800d50 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d27:	0f be d2             	movsbl %dl,%edx
  800d2a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d2d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d30:	7d 30                	jge    800d62 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d32:	83 c1 01             	add    $0x1,%ecx
  800d35:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d39:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d3b:	0f b6 11             	movzbl (%ecx),%edx
  800d3e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d41:	89 f3                	mov    %esi,%ebx
  800d43:	80 fb 09             	cmp    $0x9,%bl
  800d46:	77 d5                	ja     800d1d <strtol+0x80>
			dig = *s - '0';
  800d48:	0f be d2             	movsbl %dl,%edx
  800d4b:	83 ea 30             	sub    $0x30,%edx
  800d4e:	eb dd                	jmp    800d2d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d50:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d53:	89 f3                	mov    %esi,%ebx
  800d55:	80 fb 19             	cmp    $0x19,%bl
  800d58:	77 08                	ja     800d62 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d5a:	0f be d2             	movsbl %dl,%edx
  800d5d:	83 ea 37             	sub    $0x37,%edx
  800d60:	eb cb                	jmp    800d2d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d66:	74 05                	je     800d6d <strtol+0xd0>
		*endptr = (char *) s;
  800d68:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d6b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d6d:	89 c2                	mov    %eax,%edx
  800d6f:	f7 da                	neg    %edx
  800d71:	85 ff                	test   %edi,%edi
  800d73:	0f 45 c2             	cmovne %edx,%eax
}
  800d76:	5b                   	pop    %ebx
  800d77:	5e                   	pop    %esi
  800d78:	5f                   	pop    %edi
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    
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
