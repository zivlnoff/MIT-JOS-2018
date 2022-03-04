// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW        0x800

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf) {
//    cprintf("in pgfault,,, utf->utf_fault_va:0x%x\n", *((uintptr_t *)(utf)));

    void *addr = (void *) (utf->utf_fault_va);
    uint32_t err = utf->utf_err;
    int r;

//    cprintf("addr:0x%x\terr:%d\n", addr, err);

    extern volatile pte_t uvpt[];
    if ((err & FEC_WR) != FEC_WR || ((uvpt[(uintptr_t) addr / PGSIZE] & PTE_COW) != PTE_COW)) {
        cprintf("utf->utf_fault_va:0x%x\tutf->utf_err:%d\n", addr, err);
        panic("pgfault is not a FEC_WR or is not to a COW page");
    }
    // Check that the faulting access was (1) a write, and (2) to a
    // copy-on-write page.  If not, panic.
    // Hint:
    //   Use the read-only page table mappings at uvpt
    //   (see <inc/memlayout.h>).

    // LAB 4: Your code here.
    sys_page_alloc(0, (void *) PFTEMP, PTE_W | PTE_U | PTE_P);
    memmove((void *) PFTEMP, (void *) (ROUNDDOWN(addr, PGSIZE)), PGSIZE);

    //restore another
//    sys_page_map(0, (void *) (ROUNDDOWN(addr, PGSIZE)), 0, (void *) (ROUNDDOWN(addr, PGSIZE)), PTE_W | PTE_U | PTE_P);

    sys_page_map(0, (void *) PFTEMP, 0, (void *) (ROUNDDOWN(addr, PGSIZE)), PTE_W | PTE_U | PTE_P);
    sys_page_unmap(0, (void *) PFTEMP);

    return;
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.
    // Hint:
    //   You should make three system calls.

    // LAB 4: Your code here.

    panic("pgfault not implemented");
}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn) {
    int r;
//    cprintf("0x%x\n", pn);

    //1. Map our virtual page pn (address pn*PGSIZE) into the target envid at the same virtual address.
    if (sys_page_map(0, (void *) (pn * PGSIZE), envid, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
        panic("dupppage our own map error");
    }


    //2. the new mapping must be created copy-on-write, and then our mapping must be marked copy-on-write as well.
//    if (sys_page_map(envid, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
//        panic("dupppage target map error");
//    }

    if (sys_page_map(0, (void *) (pn * PGSIZE), 0, (void *) (pn * PGSIZE), PTE_COW | PTE_U | PTE_P) < 0) {
        panic("dupppage target map error");
    }
    return 0;
    // LAB 4: Your code here.
    panic("duppage not implemented");
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void) {
    extern void* _pgfault_upcall(void);
    //1. The parent installs pgfault() as the C-level page fault handler, using the set_pgfault_handler() function you implemented above.
    set_pgfault_handler(pgfault);

    //2. The parent calls sys_exofork() to create a child environment.
    envid_t envid = sys_exofork();

//    cprintf("envid:0x%x\n", envid);
    if (envid == 0) {
        //fix "thisenv" in the child process.
        thisenv = &envs[sys_getenvid()];
        return 0;
    }

    //3. For each writable or copy-on-write page in its address space below UTOP, the parent calls duppage,
    //   which should map the page copy-on-write into the address space of the child and then remap the page
    //   copy-on-write in its own address space. [ Note: The ordering here (i.e., marking a page as COW in
    //   the child before marking it in the parent) actually matters! Can you see why? Try to think of a
    //   specific case where reversing the order could cause trouble. ] duppage sets both PTEs so that the
    //   page is not writeable, and to contain PTE_COW in the "avail" field to distinguish copy-on-write pages
    //   from genuine read-only pages.
    //
    //   The exception stack is not remapped this way, however. Instead you need to allocate a fresh page in
    //   the child for the exception stack. Since the page fault handler will be doing the actual copying and
    //   the page fault handler runs on the exception stack, the exception stack cannot be made copy-on-write:
    //   who would copy it?
    //
    //   fork() also needs to handle pages that are present, but not writable or copy-on-write.
    //   LAB 4: Your code here.

    extern volatile pde_t uvpd[];
    extern volatile pte_t uvpt[];

    //allocate and copy a normal stack
    sys_page_alloc(envid, (void *) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
    sys_page_map(envid, (void *) (USTACKTOP - PGSIZE), 0, UTEMP, PTE_W | PTE_U | PTE_P);
    memmove(UTEMP, (void *) (USTACKTOP - PGSIZE), PGSIZE);
    sys_page_unmap(0, (void *) UTEMP);

    int i;

//    cprintf("COW page resolve ....\n");
    for (i = 0; i < (USTACKTOP - PGSIZE) / PGSIZE; i++) {
        if (uvpd[i / NPTENTRIES] == 0) {
            i += 1023;
            continue;
        }

        if ((uvpt[i] & PTE_P) == PTE_P) {
            if (((uvpt[i] & PTE_W) == PTE_W) || ((uvpt[i] & PTE_COW) == PTE_COW)) {
                duppage(envid, i);
            } else {
                sys_page_map(0, (void *) (i * PGSIZE), envid, (void *) (i * PGSIZE), PTE_SHARE | (uvpt[i] & 0x3ff));
            }
        }
    }

//    cprintf("allocate child ExceptionStack ....\n");
    sys_page_alloc(envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
    sys_page_map(envid, (void *) (UXSTACKTOP - PGSIZE), 0, UTEMP, PTE_W | PTE_U | PTE_P);
    memmove(UTEMP, (void *) (UXSTACKTOP - PGSIZE), PGSIZE);
    sys_page_unmap(0, (void *) UTEMP);

    //4. The parent sets the user page fault entrypoint for the child to look like its own.
//    set_pgfault_handler(pgfault);
//    cprintf("sys_env_set_pgfault_upcall(envid, pgfault) ....\n");
//    sys_env_set_pgfault_upcall(envid, pgfault);
    sys_env_set_pgfault_upcall(envid, _pgfault_upcall);

    //5. The child is now ready to run, so the parent marks it runnable.
//    cprintf("sys_env_set_status(envid, ENV_RUNNABLE) ....\n");
    sys_env_set_status(envid, ENV_RUNNABLE);


    return envid;
    panic("fork not implemented");
}

// Challenge!
int
sfork(void) {
    panic("sfork not implemented");
    return -E_INVAL;
}
