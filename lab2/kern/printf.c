// Simple implementation of cprintf console output for the kernel,
// based on printfmt() and the kernel console's cputchar().

#include <inc/types.h>
#include <inc/stdio.h>
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
	cputchar(ch);
    //这里会有bug！
	*cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
	int cnt = 0;

	vprintfmt((void*)putch, &cnt, fmt, ap);
	return cnt;
}

int
cprintf(const char *fmt, ...)
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
	va_end(ap);

	return cnt;
}

//不能重载？？
int memCprintf(const char *name, uintptr_t va, uint32_t pd_item, physaddr_t pa, uint32_t map_page){
    return cprintf("名称:%s\t虚拟地址:0x%x\t页目录项:0x%x\t物理地址:0x%x\t物理页:0x%x\n", name, va, pd_item, pa, map_page);
}
//0xf010efe4 ap地址固定？？？ 不是吧应该