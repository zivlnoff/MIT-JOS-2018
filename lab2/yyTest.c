#include <stdio.h>

int main(void ){
    int arr[] = {1, 5, 10};
    int* ptr = arr;
    (*ptr++) += 1;
    *ptr++;
    printf("%lld, %d, %d\n", ptr, *(ptr-1), *ptr);
}
