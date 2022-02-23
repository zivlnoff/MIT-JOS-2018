/* See COPYRIGHT for copyright information. */

#include <inc/x86.h>
#include <inc/mmu.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>
#include <inc/elf.h>

#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/monitor.h>

struct Env *envs = NULL;        // All environments
struct Env *curenv = NULL;        // The current env
static struct Env *env_free_list;    // Free environment list
// (linked by Env->env_link)

//why equals 12
#define ENVGENSHIFT    12        // >= LOGNENV

// Global descriptor table.
//
// Set up global descriptor table (GDT) with separate segments for
// kernel mode and user mode.  Segments serve many purposes on the x86.
// We don't use any of their memory-mapping capabilities, but we need
// them to switch privilege levels. 
//
// The kernel and user segments are identical except for the DPL.
// To load the SS register, the CPL must equal the DPL.  Thus,
// we must duplicate the segments for the user and the kernel.
//
// In particular, the last argument to the SEG macro used in the
// definition of gdt specifies the Descriptor Privilege Level (DPL)
// of that descriptor: 0 for kernel and 3 for user.
//
struct Segdesc gdt[] =
        {
                // 0x0 - unused (always faults -- for trapping NUL L far pointers)
                SEG_NULL,

                // 0x8 - kernel code segment
                [GD_KT >> 3] = SEG(STA_X | STA_R, 0x0, 0xffffffff, 0),

                // 0x10 - kernel data segment
                [GD_KD >> 3] = SEG(STA_W, 0x0, 0xffffffff, 0),

                // 0x18 - user code segment
                [GD_UT >> 3] = SEG(STA_X | STA_R, 0x0, 0xffffffff, 3),

                // 0x20 - user data segment
                [GD_UD >> 3] = SEG(STA_W, 0x0, 0xffffffff, 3),

                // 0x28 - tss, initialized in trap_init_percpu()
                [GD_TSS0 >> 3] = SEG_NULL
        };

struct Pseudodesc gdt_pd = {
        sizeof(gdt) - 1, (unsigned long) gdt
};

//
// Converts an envid to an env pointer.
// If checkperm is set, the specified environment must be either the
// current environment or an immediate child of the current environment.
//
// RETURNS
//   0 on success, -E_BAD_ENV on error.
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm) {
    struct Env *e;

    // If envid is zero, return the current environment.
    if (envid == 0) {
        *env_store = curenv;
        return 0;
    }

    // Look up the Env structure via the index part of the envid,
    // then check the env_id field in that struct Env
    // to ensure that the envid is not stale
    // (i.e., does not refer to a _previous_ environment
    // that used the same slot in the envs[] array).
    e = &envs[ENVX(envid)];
    if (e->env_status == ENV_FREE || e->env_id != envid) {
        *env_store = 0;
        return -E_BAD_ENV;
    }

    // Check that the calling environment has legitimate permission
    // to manipulate the specified environment.
    // If checkperm is set, the specified environment
    // must be either the current environment
    // or an immediate child of the current environment.
    if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
        *env_store = 0;
        return -E_BAD_ENV;
    }

    *env_store = e;
    return 0;
}

// Mark all environments in 'envs' as free, set their env_ids to 0,
// and insert them into the env_free_list.
// Make sure the environments are in the free list in the same order
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void) {
    // Set up envs array
    // LAB 3: Your code here.
    int i;
    for (i = NENV - 1; i >= 0; i--) {
        envs[i].env_link = env_free_list;
        env_free_list = &envs[i];
    }

    // Per-CPU part of the initialization
    env_init_percpu();
}

// Load GDT and segment descriptors.
void
env_init_percpu(void) {
    lgdt(&gdt_pd);
    // The kernel never uses GS or FS, so we leave those set to
    // the user data segment.
    asm volatile("movw %%ax,%%gs" : : "a" (GD_UD | 3));
    asm volatile("movw %%ax,%%fs" : : "a" (GD_UD | 3));
    // The kernel does use ES, DS, and SS.  We'll change between
    // the kernel and user data segments as needed.
    asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
    asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
    asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
    // Load the kernel text segment into CS.
    asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
    // For good measure, clear the local descriptor table (LDT),
    // since we don't use it.
    lldt(0);
}

//
// Initialize the kernel virtual memory layout for environment e.
// Allocate a page directory, set e->env_pgdir accordingly,
// and initialize the kernel portion of the new environment's address space.
// Do NOT (yet) map anything into the user portion
// of the environment's virtual address space.
//
// Returns 0 on success, < 0 on error.  Errors include:
//	-E_NO_MEM if page directory or table could not be allocated.
//
static int
env_setup_vm(struct Env *e) {
    cprintf("************* Now we set up a env's vm. **************\n");

    int i;
    struct PageInfo *p = NULL;

    // Allocate a page for the page directory
    if (!(p = page_alloc(ALLOC_ZERO)))
        return -E_NO_MEM;

    // Now, set e->env_pgdir and initialize the page directory.
    //
    // Hint:
    //    - The VA space of all envs is identical above UTOP
    //	(except at UVPT, which we've set below).
    //	See inc/memlayout.h for permissions and layout.
    //	Can you use kern_pgdir as a template?  Hint: Yes.
    //	(Make sure you got the permissions right in Lab 2.)
    //    - The initial VA below UTOP is empty.
    //    - You do not need to make any more calls to page_alloc.
    //    - Note: In general, pp_ref is not maintained for
    //	physical pages mapped only above UTOP, but env_pgdir
    //	is an exception -- you need to increment env_pgdir's
    //	pp_ref for env_free to work correctly.
    //    - The functions in kern/pmap.h are handy.

    // LAB 3: Your code here.
    e->env_pgdir = page2kva(p);
    p->pp_ref++;

    // imitate the kern_pgdir above UTOP
    cprintf("UTOP:0x%x\te->env_pgdor:0x%x\tsizeof(pde_t):%d\n", UTOP, e->env_pgdir, sizeof(pde_t));
    uint32_t utop_off = PDX(UTOP);
    cprintf("UTOP:0x%x\tutop_off:0x%x\te->env_pgdir + utop_off:0x%x\tkern_pgdir + utop_off:%x\tsizeof(pde_t) * (NPDENTRIES - utop_off)):%d\n",
            UTOP, utop_off, e->env_pgdir + utop_off, kern_pgdir + utop_off, sizeof(pde_t) * (NPDENTRIES - utop_off));
    memcpy(e->env_pgdir + utop_off, kern_pgdir + utop_off, sizeof(pde_t) * (NPDENTRIES - utop_off));

//    lcr3(PADDR(e->env_pgdir));
//    panic("check cp");

    // UVPT maps the env's own page table read-only.
    // Permissions: kernel R, user R
    e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;

    cprintf("************* Now we successfully set up a env's vm. **************\n");
    return 0;
}

//
// Allocates and initializes a new environment.
// On success, the new environment is stored in *newenv_store.
//
// Returns 0 on success, < 0 on failure.  Errors include:
//	-E_NO_FREE_ENV if all NENV environments are allocated
//	-E_NO_MEM on memory exhaustion
//

int
env_alloc(struct Env **newenv_store, envid_t parent_id) {
    //why newenv_store use double-pointer
    cprintf("************* Now we alloc a env. **************\n");

    int32_t generation;
    int r;
    struct Env *e;

    if (!(e = env_free_list))
        return -E_NO_FREE_ENV;

    // Allocate and set up the page directory for this environment.
    if ((r = env_setup_vm(e)) < 0)
        return r;

    // Generate an env_id for this environment.
    generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
    if (generation <= 0)    // Don't create a negative env_id.
        generation = 1 << ENVGENSHIFT;
    e->env_id = generation | (e - envs);

    // Set the basic status variables.
    e->env_parent_id = parent_id;
    e->env_type = ENV_TYPE_USER;
    e->env_status = ENV_RUNNABLE;
    e->env_runs = 0;

    // Clear out all the saved register state,
    // to prevent the register values
    // of a prior environment inhabiting this Env structure
    // from "leaking" into our new environment.
    memset(&e->env_tf, 0, sizeof(e->env_tf));

    // Set up appropriate initial values for the segment registers.
    // GD_UD is the user data segment selector in the GDT, and
    // GD_UT is the user text segment selector (see inc/memlayout.h).
    // The low 2 bits of each segment register contains the
    // Requestor Privilege Level (RPL); 3 means user mode.  When
    // we switch privilege levels, the hardware does various
    // checks involving the RPL and the Descriptor Privilege Level
    // (DPL) stored in the descriptors themselves.
    e->env_tf.tf_ds = GD_UD | 3;
    e->env_tf.tf_es = GD_UD | 3;
    e->env_tf.tf_ss = GD_UD | 3;
    e->env_tf.tf_esp = USTACKTOP;
    e->env_tf.tf_cs = GD_UT | 3;
    // You will set e->env_tf.tf_eip later.

    // commit the allocation
    env_free_list = e->env_link;
    *newenv_store = e;

    //curenv??
    cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
    return 0;
}

//
// Allocate len bytes of physical memory for environment env,
// and map it at virtual address va in the environment's address space.
// Does not zero or otherwise initialize the mapped pages in any way.
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len) {
    // LAB 3: Your code here.
    // (But only if you need it for load_icode.)
    //
    // Hint: It is easier to use region_alloc if the caller can pass
    //   'va' and 'len' values that are not page-aligned.
    //   You should round va down, and round (va + len) up.
    //   (Watch out for corner-cases!)
    pde_t *pgdir = e->env_pgdir;
    uintptr_t begin = ROUNDDOWN((uintptr_t) va, PGSIZE), end = ROUNDUP((uintptr_t) va + len, PGSIZE);
    for (; begin < end; begin += PGSIZE) {
//        if (!page_lookup(pgdir, (void *) begin, NULL)) {
            cprintf("begin:0x%x\tend:0x%x\n", begin, end);
            //alloc_flag ??? why false??? sb fz
//            page_insert(pgdir, page_alloc(false), (void *) begin, PTE_U | PTE_W);
            page_insert(pgdir, page_alloc(ALLOC_ZERO), (void *) begin, PTE_U | PTE_W);
//        }
    }
}

//
// Set up the initial program binary, stack, and processor flags
// for a user process.
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
//
// This function loads all loadable segments from the ELF binary image
// into the environment's user memory, starting at the appropriate
// virtual addresses indicated in the ELF program header.
// At the same time it clears to zero any portions of these segments
// that are marked in the program header as being mapped
// but not actually present in the ELF file - i.e., the program's bss section.
//
// All this is very similar to what our boot loader does, except the boot
// loader also needs to read the code from disk.  Take a look at
// boot/main.c to get ideas.
//
// Finally, this function maps one page for the program's initial stack.
//
// load_icode panics if it encounters problems.
//  - How might load_icode fail?  What might be wrong with the given input?
//
static void
load_icode(struct Env *e, uint8_t *binary) {
    cprintf("************* Now we load_icode about a env e. **************\n");

    // Hints:
    //  Load each program segment into virtual memory
    //  at the address specified in the ELF segment header.
    //  You should only load segments with ph->p_type == ELF_PROG_LOAD.
    //  Each segment's virtual address can be found in ph->p_va
    //  and its size in memory can be found in ph->p_memsz.
    //  The ph->p_filesz bytes from the ELF binary, starting at
    //  'binary + ph->p_offset', should be copied to virtual address
    //  ph->p_va.  Any remaining memory bytes should be cleared to zero.
    //  (The ELF header should have ph->p_filesz <= ph->p_memsz.)
    //  Use functions from the previous lab to allocate and map pages.
    //
    //  All page protection bits should be user read/write for now.
    //  ELF segments are not necessarily page-aligned, but you can
    //  assume for this function that no two segments will touch
    //  the same virtual page.
    //
    //  You may find a function like region_alloc useful.
    //
    //  Loading the segments is much simpler if you can move data
    //  directly into the virtual addresses stored in the ELF binary.
    //  So which page directory should be in force during
    //  this function?
    //
    //  You must also do something with the program's entry point,
    //  to make sure that the environment starts executing there.
    //  What?  (See env_run() and env_pop_tf() below.)

    // LAB 3: Your code here.
    struct Elf *elfHdr = (struct Elf *) binary;

    if (elfHdr->e_magic != ELF_MAGIC) {
        //todo;
    }

    struct Proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    // ignores ph flags why?
    cprintf("************* Now we load each program segment. **************\n");
    ph = (struct Proghdr *) (binary + elfHdr->e_phoff);
    eph = ph + elfHdr->e_phnum;
    for (; ph < eph; ph++) {
        if (ph->p_type == ELF_PROG_LOAD) {
            cprintf("ph->p_type:%x\t ph->p_offset:0x%x\t ph->p_va:0x%x\t ph->p_pa:0x%x\t ph->p_filesz:0x%x\t ph->p_memsz:0x%x\t ph->p_flags:%x\t ph->p_align:0x%x\t\n",
                    ph->p_type, ph->p_offset, ph->p_va, ph->p_pa, ph->p_filesz, ph->p_memsz, ph->p_flags, ph->p_align);

            //map
            region_alloc(e, (void *) ph->p_va, ph->p_memsz);

            //copy  filesz or memsz??
            //where the .bss section, if it's reserved in middle space? and below is wrong.
//            memcpy(ph->p_va, binary + ph->p_offset, ph->p_filesz);
        }
    }

    //copy
    //clear the .bss section
    //elf analysis make me anxious!!! we need?
    cprintf("************* Now we copy each section which should load. **************\n");
    struct Secthdr *sectHdr = (struct Secthdr *) (binary + elfHdr->e_shoff);
    cprintf("rcr3():0x%x\n", rcr3());
    lcr3(PADDR(e->env_pgdir));
    cprintf("rcr3():0x%x\n", rcr3());
    for (int i = 0; i < elfHdr->e_shnum; i++) {
        if (sectHdr->sh_addr != 0 && sectHdr->sh_type != ELF_SHT_NOBITS) {
            cprintf("(void *) sectHdr->sh_addr:0x%x\tsectHdr->sh_offset:0x%x\tsectHdr->sh_size:0x%x\n", sectHdr->sh_addr, sectHdr->sh_offset, sectHdr->sh_size);
            memcpy((void *) sectHdr->sh_addr, binary + sectHdr->sh_offset, sectHdr->sh_size);
        }
        sectHdr++;
    }
    //necessary?
    lcr3(PADDR(kern_pgdir));

    // Now map one page for the program's initial stack
    // at virtual address USTACKTOP - PGSIZE.

    // LAB 3: Your code here.
    cprintf("************* Now we map one page for the program's initial stack. **************\n");
    region_alloc(e, (void *) USTACKTOP - PGSIZE, PGSIZE);

    //set environments enter pointer
    e->env_tf.tf_eip = elfHdr->e_entry;
}

//
// Allocates a new env with env_alloc, loads the named elf
// binary into it with load_icode, and sets its env_type.
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type) {
    cprintf("************* Now we create a env. **************\n");
    // LAB 3: Your code here.
    struct Env *Env = NULL;

    switch (env_alloc(&Env, 0)) {
        case -E_NO_FREE_ENV:
            //todo
            break;
        case -E_NO_MEM:
            //todo
            break;
        default:
            //todo
            break;
    };

    load_icode(Env, binary);

    Env->env_type = type;
}

//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e) {
    pte_t *pt;
    uint32_t pdeno, pteno;
    physaddr_t pa;

    // If freeing the current environment, switch to kern_pgdir
    // before freeing the page directory, just in case the page
    // gets reused.
    if (e == curenv)
        lcr3(PADDR(kern_pgdir));

    // Note the environment's demise.
    cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

    // Flush all mapped pages in the user portion of the address space
    static_assert(UTOP % PTSIZE == 0);
    for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {

        // only look at mapped page tables
        if (!(e->env_pgdir[pdeno] & PTE_P))
            continue;

        // find the pa and va of the page table
        pa = PTE_ADDR(e->env_pgdir[pdeno]);
        pt = (pte_t *) KADDR(pa);

        // unmap all PTEs in this page table
        for (pteno = 0; pteno <= PTX(~0); pteno++) {
            if (pt[pteno] & PTE_P)
                page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
        }

        // free the page table itself
        e->env_pgdir[pdeno] = 0;
        page_decref(pa2page(pa));
    }

    // free the page directory
    pa = PADDR(e->env_pgdir);
    e->env_pgdir = 0;
    page_decref(pa2page(pa));

    // return the environment to the free list
    e->env_status = ENV_FREE;
    e->env_link = env_free_list;
    env_free_list = e;
}

//
// Frees environment e.
//
void
env_destroy(struct Env *e) {
    env_free(e);

    cprintf("Destroyed the only environment - nothing more to do!\n");
    while (1)
        monitor(NULL);
}


//
// restores the register values in the trapframe with the 'iret' instruction.
// this exits the kernel and starts executing some environment's code.
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf) {
    asm volatile(
    "\tmovl %0,%%esp\n"
    "\tpopal\n"
    "\tpopl %%es\n"
    "\tpopl %%ds\n"
    "\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
    "\tiret\n"
    : : "g" (tf) : "memory");
    panic("iret failed");  /* mostly to placate the compiler */
}

//
// Context switch from curenv to env e.
// Note: if this is the first call to env_run, curenv is NULL.
//
// This function does not return.
//
void
env_run(struct Env *e) {
    cprintf("************* Now we run a env. **************\n");
    // Step 1: If this is a context switch (a new environment is running):
    //	   1. Set the current environment (if any) back to
    //	      ENV_RUNNABLE if it is ENV_RUNNING (think about
    //	      what other states it can be in),
    //	   2. Set 'curenv' to the new environment,
    //	   3. Set its status to ENV_RUNNING,
    //	   4. Update its 'env_runs' counter,
    //	   5. Use lcr3() to switch to its address space.
    // Step 2: Use env_pop_tf() to restore the environment's
    //	   registers and drop into user mode in the
    //	   environment.

    // Hint: This function loads the new environment's state from
    //	e->env_tf.  Go back through the code you wrote above
    //	and make sure you have set the relevant parts of
    //	e->env_tf to sensible values.

    // LAB 3: Your code here.
    if (curenv != NULL) {
        if (curenv->env_status == ENV_RUNNING) {
            curenv->env_status = ENV_RUNNABLE;
        }
    }

    curenv = e;
    //?????????????????????????????????why this fault?
//    e->env_status = ENV_RUNNABLE;
    e->env_status = ENV_RUNNING;
    e->env_runs++;

    lcr3(PADDR(e->env_pgdir));

    cprintf("e->env_tf.tf_cs:0x%x\n", e->env_tf.tf_cs);
    env_pop_tf(&e->env_tf);
    panic("env_run not yet implemented");
}

