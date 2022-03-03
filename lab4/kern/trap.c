#include <inc/mmu.h>
#include <inc/x86.h>
#include <inc/assert.h>

#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/env.h>
#include <kern/syscall.h>
#include <kern/sched.h>
#include <kern/kclock.h>
#include <kern/picirq.h>
#include <kern/cpu.h>
#include <kern/spinlock.h>

static struct Taskstate ts;

/* For debugging, so print_trapframe can distinguish between printing
 * a saved trapframe and printing the current trapframe and print some
 * additional information in the latter case.
 */
static struct Trapframe *last_tf;

/* Interrupt descriptor table.  (Must be built at run time because
 * shifted function addresses can't be represented in relocation records.)
 */
struct Gatedesc idt[256] = {{0}};
struct Pseudodesc idt_pd = {
        sizeof(idt) - 1, (uint32_t) idt
};


static const char *trapname(int trapno) {
    static const char *const excnames[] = {
            "Divide error",
            "Debug",
            "Non-Maskable Interrupt",
            "Breakpoint",
            "Overflow",
            "BOUND Range Exceeded",
            "Invalid Opcode",
            "Device Not Available",
            "Double Fault",
            "Coprocessor Segment Overrun",
            "Invalid TSS",
            "Segment Not Present",
            "Stack Fault",
            "General Protection",
            "Page Fault",
            "(unknown trap)",
            "x87 FPU Floating-Point Error",
            "Alignment Check",
            "Machine-Check",
            "SIMD Floating-Point Exception"
    };

    if (trapno < ARRAY_SIZE(excnames))
        return excnames[trapno];
    if (trapno == T_SYSCALL)
        return "System call";
    return "(unknown trap)";
}


void
trap_init(void) {
    extern struct Segdesc gdt[];

    // LAB 3: Your code here.
    extern char handler0[], handler1[], handler2[], handler3[], handler4[], handler5[], handler6[], handler7[], handler8[], handler10[], handler11[], handler12[], handler13[], handler14[], handler16[], handler17[], handler18[], handler19[];
    char *handler[] = {handler0, handler1, handler2, handler3, handler4, handler5, handler6, handler7, handler8,
                       NULL, handler10, handler11, handler12, handler13, handler14, NULL, handler16, handler17,
                       handler18, handler19};
    //can we distinguish trap or interupt and CPL DPL RPL IOPL
    for (int i = 0; i < 20; i++) {
        if (i == T_BRKPT) {
            SETGATE(idt[i], 1, GD_KT, handler[i], 3);
        } else {
            SETGATE(idt[i], 1, GD_KT, handler[i], 0);
        }
        cprintf("idt[%d]\toff:0x%x\n", i, (idt[i].gd_off_31_16 << 16) + idt[i].gd_off_15_0);
    }

    extern char handler48[];
    SETGATE(idt[T_SYSCALL], 1, GD_KT, handler48, 3);
    // Per-CPU setup
    trap_init_percpu();
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void) {
    // The example code here sets up the Task State Segment (TSS) and
    // the TSS descriptor for CPU 0. But it is incorrect if we are
    // running on other CPUs because each CPU has its own kernel stack.
    // Fix the code so that it works for all CPUs.
    //
    // Hints:
    //   - The macro "thiscpu" always refers to the current CPU's
    //     struct CpuInfo;
    //   - The ID of the current CPU is given by cpunum() or
    //     thiscpu->cpu_id;
    //   - Use "thiscpu->cpu_ts" as the TSS for the current CPU,
    //     rather than the global "ts" variable;
    //   - Use gdt[(GD_TSS0 >> 3) + i] for CPU i's TSS descriptor;
    //   - You mapped the per-CPU kernel stacks in mem_init_mp()
    //   - Initialize cpu_ts.ts_iomb to prevent unauthorized environments
    //     from doing IO (0 is not the correct value!)
    //
    // ltr sets a 'busy' flag in the TSS selector, so if you
    // accidentally load the same TSS on more than one CPU, you'll
    // get a triple fault.  If you set up an individual CPU's TSS
    // wrong, you may not get a fault until you try to return from
    // user space on that CPU.
    //
    // LAB 4: Your code here:

    // Setup a TSS so that we get the right stack
    // when we trap to the kernel.
    thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - (KSTKSIZE + KSTKGAP) * cpunum();
    thiscpu->cpu_ts.ts_ss0 = GD_KD;
    thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);

    // Initialize the TSS slot of the gdt.
    gdt[(GD_TSS0 >> 3) + cpunum()] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
                                           sizeof(struct Taskstate) - 1, 0);

    //distinguish system or application cpu? need?
    //why i don't do that and i go over? whywhy??
//    if (cpunum() == 0) {
//        gdt[(GD_TSS0 >> 3) + cpunum()].sd_s = 0;
//        cprintf("system cpu%d\n", cpunum());
//    } else {
//        gdt[(GD_TSS0 >> 3) + cpunum()].sd_s = 1;
//        cprintf("application cpu%d\n", cpunum());
//    }

    gdt[(GD_TSS0 >> 3) + cpunum()].sd_s = 0;

    cprintf("cpunum():%d\t&(thiscpu->cpu_ts):0x%x\tts_esp0:0x%x\tts_ss0:0x%x\tGD_TSS0+(cpunum()<<3):0x%x\n", cpunum(),
            (uint32_t) (&(thiscpu->cpu_ts)), thiscpu->cpu_ts.ts_esp0,
            thiscpu->cpu_ts.ts_ss0, GD_TSS0 + (cpunum() << 3));

    // Load the TSS selector (like other segment selectors, the
    // bottom three bits are special; we leave them 0)

    cprintf("gdt[(GD_TSS0 >> 3) + cpunum().sd_base_31_0]:0x%x\tsizeof(struct CpuInfo):0x%x\n",
            (gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_31_24 << 24) +
            (gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_23_16 << 16) + gdt[(GD_TSS0 >> 3) + cpunum()].sd_base_15_0,
            sizeof(struct CpuInfo));
    //question what?
    ltr((GD_TSS0 + (cpunum() << 3)));

    // Load the IDT
    lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf) {
    cprintf("TRAP frame at %p\n", tf);
    print_regs(&tf->tf_regs);
    cprintf("  es   0x----%04x\n", tf->tf_es);
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
    // If this trap was a page fault that just happened
    // (so %cr2 is meaningful), print the faulting linear address.
    if (tf == last_tf && tf->tf_trapno == T_PGFLT)
        cprintf("  cr2  0x%08x\n", rcr2());
    cprintf("  err  0x%08x", tf->tf_err);
    // For page faults, print decoded fault error code:
    // U/K=fault occurred in user/kernel mode
    // W/R=a write/read caused the fault
    // PR=a protection violation caused the fault (NP=page not present).
    if (tf->tf_trapno == T_PGFLT)
        cprintf(" [%s, %s, %s]\n",
                tf->tf_err & 4 ? "user" : "kernel",
                tf->tf_err & 2 ? "write" : "read",
                tf->tf_err & 1 ? "protection" : "not-present");
    else
        cprintf("\n");
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x\n", tf->tf_eflags);
    if ((tf->tf_cs & 3) != 0) {
        cprintf("  esp  0x%08x\n", tf->tf_esp);
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
    }
}

void
print_regs(struct PushRegs *regs) {
    cprintf("  edi  0x%08x\n", regs->reg_edi);
    cprintf("  esi  0x%08x\n", regs->reg_esi);
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
    cprintf("  edx  0x%08x\n", regs->reg_edx);
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
    cprintf("  eax  0x%08x\n", regs->reg_eax);
}

static void
trap_dispatch(struct Trapframe *tf) {
    // Handle processor exceptions.
    // LAB 3: Your code here.
    switch (tf->tf_trapno) {
        case 0:
            cprintf("Divide Error fault\n");
            break;
        case 1:
            cprintf("Debug exceptions. Hints: An exception handler can examine the debug registers to determine which condition caused the exception.\n");
            break;
        case 2:
            //todo
            break;
        case 3:
            cprintf("Breakpoint INT 3 trap\n");
            monitor(tf);
            break;
        case 4:
            cprintf("Overflow trap\n");
            break;
        case 5:
            cprintf("Bounds Check fault\n");
            break;
        case 6:
            cprintf("Invalid Opcode fault\n");
            break;
        case 7:
            //todo
            break;
        case 8:
            cprintf("Double Fault\n");
            break;
        case 10:
            //todo
            break;
        case 11:
            //todo
            break;
        case 12:
            //todo
            break;
        case 13:
            cprintf("General Protection Exception\n");
            break;
        case 14:
//            cprintf("Page Fault\n");
            page_fault_handler(tf);
            break;
        case 16:
            //todo
            break;
        case 17:
            //todo
            break;
        case 18:
            //todo
            break;
        case 19:
            //todo
            break;
        case T_SYSCALL:
//            cprintf("T_SYSCALL\n");

            tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx,
                                          tf->tf_regs.reg_ebx, tf->tf_regs.reg_edi, tf->tf_regs.reg_esi);
            return;
            //ret reserved in eax
        default:
            cprintf("Unknown Trap\n");
            break;
    }


    // Unexpected trap: The user process or the kernel has a bug.
    print_trapframe(tf);
    if (tf->tf_cs == GD_KT)
        panic("unhandled trap in kernel");
    else {
        env_destroy(curenv);
        return;
    }
}

void
trap(struct Trapframe *tf) {
    // The environment may have set DF and some versions
    // of GCC rely on DF being clear
    asm volatile("cld":: : "cc");

    // Halt the CPU if some other CPU has called panic()
    extern char *panicstr;
    if (panicstr)
            asm volatile("hlt");

    // Re-acqurie the big kernel lock if we were halted in
    // sched_yield()
    if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
        lock_kernel();

    // Check that interrupts are disabled.  If this assertion
    // fails, DO NOT be tempted to fix it by inserting a "cli" in
    // the interrupt path.
    assert(!(read_eflags() & FL_IF));

//    cprintf("Incoming TRAP frame at %p\n", tf);
//    print_trapframe(tf);

    if ((tf->tf_cs & 3) == 3) {
        lock_kernel();
//        cprintf("Trapped from user mode.\n");
        // Trapped from user mode.
        // Acquire the big kernel lock before doing any
        // serious kernel work.
        // LAB 4: Your code here.
        assert(curenv);

        // Garbage collect if current enviroment is a zombie
        if (curenv->env_status == ENV_DYING) {
            env_free(curenv);
            curenv = NULL;
            sched_yield();
        }

        // Copy trap frame (which is currently on the stack)
        // into 'curenv->env_tf', so that running the environment
        // will restart at the trap point.
        curenv->env_tf = *tf;
        // The trapframe on the stack should be ignored from here on.
        tf = &curenv->env_tf;
    }

    // Record that tf is the last real trapframe so
    // print_trapframe can print some additional information.
    last_tf = tf;

    // Dispatch based on what type of trap occurred
    trap_dispatch(tf);

    // If we made it to this point, then no other environment was
    // scheduled, so we should return to the current environment
    // if doing so makes sense.
    if (curenv && curenv->env_status == ENV_RUNNING)
        env_run(curenv);
    else
        sched_yield();

//    // Return to the current environment, which should be running.
//    assert(curenv && curenv->env_status == ENV_RUNNING);
//    env_run(curenv);
}

void
page_fault_handler(struct Trapframe *tf) {
//    cprintf("************* Now we handle page fault. **************\n");
    uint32_t fault_va;

    // Read processor's CR2 register to find the faulting address
    fault_va = rcr2();

    // Handle kernel-mode page faults.

    // LAB 3: Your code here.
    if ((tf->tf_cs & 3) == 0) {
        print_trapframe(tf);
        panic("kernel-mode exception\n");
    }
    // We've already handled kernel-mode exceptions, so if we get here,
    // the page fault happened in user mode.

    // Call the environment's page fault upcall, if one exists.  Set up a
    // page fault stack frame on the user exception stack (below
    // UXSTACKTOP), then branch to curenv->env_pgfault_upcall.

    if (curenv->env_pgfault_upcall == NULL) {
        // Destroy the environment that caused the fault.
        cprintf("[%08x] user fault va %08x ip %08x\n",
                curenv->env_id, fault_va, tf->tf_eip);
        print_trapframe(tf);
        env_destroy(curenv);
    }

    user_mem_assert(curenv, (void *) UXSTACKTOP - PGSIZE, PGSIZE, PTE_W);

    struct UTrapframe *uTrapframe;
    if (tf->tf_esp >= UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP) {
        // The page fault upcall might cause another page fault, in which case
        // we branch to the page fault upcall recursively, pushing another
        // page fault stack frame on top of the user exception stack.
        uTrapframe = (struct UTrapframe *) (tf->tf_esp - 4 - sizeof(struct UTrapframe));

        if ((uintptr_t) uTrapframe < UXSTACKTOP - PGSIZE) {
            env_destroy(curenv);
        }
    } else {
        uTrapframe = (struct UTrapframe *) (UXSTACKTOP - sizeof(struct UTrapframe));
    }

    uTrapframe->utf_esp = tf->tf_esp;
    uTrapframe->utf_eflags = tf->tf_eflags;
    uTrapframe->utf_eip = tf->tf_eip;
    uTrapframe->utf_regs = tf->tf_regs;
    uTrapframe->utf_err = tf->tf_err;
    uTrapframe->utf_fault_va = fault_va;
    // It is convenient for our code which returns from a page fault
    // (lib/pfentry.S) to have one word of scratch space at the top of the
    // trap-time stack; it allows us to more easily restore the eip/esp. In
    // the non-recursive case, we don't have to worry about this because
    // the top of the regular user stack is free.  In the recursive case,
    // this means we have to leave an extra word between the current top of
    // the exception stack and the new stack frame because the exception
    // stack _is_ the trap-time stack.

    // If there's no page fault upcall, the environment didn't allocate a
    // page for its exception stack or can't write to it, or the exception
    // stack overflows, then destroy the environment that caused the fault.
    // Note that the grade script assumes you will first check for the page
    // fault upcall and print the "user fault va" message below if there is
    // none.  The remaining three checks can be combined into a single test.
    //
    // Hints:
    //   user_mem_assert() and env_run() are useful here.
    //   To change what the user environment runs, modify 'curenv->env_tf'
    //   (the 'tf' variable points at 'curenv->env_tf').

    tf->tf_eip = (uintptr_t) curenv->env_pgfault_upcall;
    tf->tf_esp = (uintptr_t) uTrapframe;
//    cprintf("uTrapframe:0x%x\tuTrapframe->utf_regs.reg_ebp:0x%x\tuTrapframe->utf_regs.reg_esp:0x%x\n", uTrapframe,
//            uTrapframe->utf_regs.reg_ebp, uTrapframe->utf_esp);
    env_run(curenv);
    // LAB 4: Your code here.
}
