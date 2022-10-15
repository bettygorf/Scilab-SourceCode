#include "../machine.h"

/* ip is a pointer to a FORTRAN variable coming from SCILAB
which is itself a pointer to an array of n chars typically
coming from a C function
   ccharf converts this char array into a double array in op 
   moreover, pointer ip is freed */

void C2F(ccharf)(n,ip,op)
int *n;
char **ip;
int *op;
{
  int i = 0;
  cvstr_(n,op,*ip,&i,*n);
  free(*ip);
}
