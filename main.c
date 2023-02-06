#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern char* sdiv(unsigned int base, char *d, char *s1, char *s2);

int main(int argc, char * argv[])
{
    if(argc != 4)
    {
        printf("Wrong argument number\n");
        return 1;
    }
    char *str1 = argv[1];
    char *str2 = argv[2];
    char *base_arg = argv[3];
    unsigned int base = 0;
    sscanf(base_arg, "%d", &base);
    if (base <= 1 || base >= 37)
    {
        printf("Choose a number base between 2 and 36");
        return 0;
    }
    unsigned int size_1 = 0, size_2 = 0;
    unsigned int i = 0;
    while(str1[i] != 0)
    {
        if (str1[i] == '0' && size_1 == 0) ++i;
        else {
            ++size_1;
            ++i;
        }
    }
    i = 0;
    while(str2[i] != 0)
    {
        if (str2[i] == '0' && size_2 == 0) ++i;
        else {
            ++size_2;
            ++i;
        }
    }
    if (size_2 == 0)
    {
        printf("Division by 0 is not possible");
        return 0;
    }
    char* divisor = malloc(size_1+1);
    char* dividend = malloc(size_2+1);
    for (int i = 0; i < size_1; ++i)
    {
        divisor[size_1-1-i] = str1[strlen(str1)-1-i];
    }
    divisor[size_1] = '\0';
    for (int i = 0; i < size_2; ++i)
    {
        dividend[size_2-1-i] = str2[strlen(str2)-1-i];
    }
    dividend[size_2] = '\0';
    int result_size = size_1 - size_2 + 1;
    if (result_size < 1) result_size = 1;
    char *d = (char*)malloc((result_size)*sizeof(char));
    i = 0;
    while(i != result_size) d[i++] = '0';
    printf("Base: %d\n%s : %s = ", base, divisor, dividend);

    sdiv(base, d, divisor, dividend);
    d[result_size] = '\0';

    printf("%s\nRest = %s\n\n", d, divisor);
    free(d);
    return 0;
}
