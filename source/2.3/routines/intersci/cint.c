#include "../machine.h"

/* ip is a pointer to a FORTRAN variable coming from SCILAB
which is itself a pointer to an array of n integers typically
coming from a C function
   cint converts this integer array into a double array in op */

void C2F(cint)(n,ip,op)
int *n;
int *ip[];
double *op;
{
  int i;
  for (i = 0; i < *n; i++)
    op[i]=(double)(*ip)[i];
}
