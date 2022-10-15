/* Copyright INRIA */
#include "../machine.h"

/* ip is a pointer to a FORTRAN variable coming from SCILAB
which is itself a pointer to an array of n integers typically
allocated in a C function
   int2int copy op fortran integer array into  integer array in ip */

void C2F(int2cint)(n,ip,op)
int *n;
integer *ip[];
integer *op;
{
  int i;
  for (i = 0; i < *n; i++)
      (*ip)[i]=op[i];
}
