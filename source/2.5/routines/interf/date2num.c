#include "../machine.h"
#include <time.h>
#include <locale.h>
#include <stdio.h>
#define SLENGTH 80

int C2F(date2num)(w)
int *w;
{
    char nowstr[SLENGTH];
    time_t nowbin;
    struct tm *nowstruct;

    (void)setlocale(LC_ALL, "");

    if (time(&nowbin) == (time_t) - 1)
      return 1;
    nowstruct = localtime(&nowbin);

    if (strftime(nowstr, SLENGTH, " %Y:%m:%V:%j:%u:%d:%T", nowstruct) == (size_t) 0) 
        return 2;

    sscanf(nowstr,"%d:%d:%d:%d:%d:%d:%d:%d:%d",w,(int *)(w+1),(int *)(w+2),
	  (int *)(w+3),(int *)(w+4),(int *)(w+5),(int *)(w+6),(int *)(w+7),
	   (int *)(w+8));
    return 0;

}
