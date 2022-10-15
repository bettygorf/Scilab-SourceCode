/* Copyright INRIA */
#include "../machine.h"

/* ip is a pointer to a FORTRAN variable coming from SCILAB
which is itself a pointer to an array of n chars typically
coming from a C function
   cchar converts this char array into a double array in op */

void C2F(cchar)(n,ip,op)
int *n;
char **ip;
int *op;
{
  int i = 0;
  F2C(cvstr)(n,op,*ip,&i,*n);
}
