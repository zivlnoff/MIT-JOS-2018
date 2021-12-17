/* See COPYRIGHT for copyright information. */

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/assert.h>

#include <kern/monitor.h>
#include <kern/console.h>
#include <kern/pmap.h>
#include <kern/kclock.h>
#include <kern/env.h>
#include <kern/trap.h>

// Test the stack backtrace function (lab 1 only)
void
test_backtrace(int x) {
    cprintf("entering test_backtrace %d\n", x);
    if (x <= 0)
        mon_backtrace(0, 0, 0);
    else {
        test_backtrace(x - 1);
    }
    cprintf("leaving test_backtrace %d\n", x);
}

//入口
void
i386_init(void) {
    extern char edata[], end[];

    // Before doing anything else, complete the ELF loading process.
    // Clear the uninitialized global data (BSS) section of our program.
    // This ensures that all static/global variables start out zero.

    //我目前觉得不应该这么做，可能我对.bss段不太了解，哦，我对调试用的符号表也没有很熟悉
    memset(edata, 0, end - edata);

    // Initialize the console.
    // Can't call cprintf until after we do this!
    cons_init();

    cprintf("\nlab1 start------------------------------------------------------------------------------------------------\n");

    cprintf("6828 decimal is %o octal!\n", 6828);
    //comparable little-and big-endian
    unsigned int i = 0x00646c72;//100-d 6c-l 72-r
    cprintf("H%x Wo%s!\n", 57616, &i);//57616-e110
    // Test the stack backtrace function (lab 1 only)
    test_backtrace(5);

    cprintf("lab1 end--------------------------------------------------------------------------------------------------\n\n");

    cprintf("lab2 start------------------------------------------------------------------------------------------------\n");
    // Lab 2 memory management initialization functions
    mem_init();

    cprintf("lab2 end--------------------------------------------------------------------------------------------------\n\n");

    cprintf("lab3 start--------------------------------------------------------------------------------------------------\n\n");

    // Lab 3 user environment initialization functions
    env_init();
    trap_init();

#if defined(TEST)
    // Don't touch -- used by grading script!
    ENV_CREATE(TEST, ENV_TYPE_USER);
#else
    // Touch all you want.
    ENV_CREATE(user_hello, ENV_TYPE_USER);
#endif // TEST*

    // We only have one user environment for now, so just run it.
    env_run(&envs[0]);
}


/*
 * Variable panicstr contains argument to first call to panic; used as flag
 * to indicate that the kernel has already called panic.
 */
const char *panicstr;

/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...) {
    va_list ap;

    if (panicstr)
        goto dead;
    panicstr = fmt;

    // Be extra sure that the machine is in as reasonable state
    asm volatile("cli; cld");

    va_start(ap, fmt);
    cprintf("kernel panic at %s:%d: ", file, line);
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

    dead:
    /* break into the kernel monitor */
    while (1)
        monitor(NULL);
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt, ...) {
    va_list ap;

    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d: ", file, line);
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);
}
