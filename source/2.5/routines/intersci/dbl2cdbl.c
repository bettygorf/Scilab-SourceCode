/* Copyright INRIA */
#include "../machine.h"

/* ip is a pointer to a FORTRAN variable coming from SCILAB
which is itself a pointer to an array of n double typically
allocated in a C function
   int2int copy op fortran double precision array into double array in ip */

void C2F(dbl2cdbl)(n,ip,op)
int *n;
double *ip[];
double *op;
{
  int i;
  for (i = 0; i < *n; i++)
      (*ip)[i]=op[i];
}
