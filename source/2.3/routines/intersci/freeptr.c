#include "../machine.h"

/* see cdoublef.c, cintf.c  (pointer ip is freed) */

void C2F(freeptr)(ip)
double *ip[];
{  free((char *)(*ip));
}
