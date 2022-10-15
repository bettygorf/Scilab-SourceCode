#include "../machine.h"   

/* ip is a pointer to a FORTRAN variable coming from SCILAB
which is itself a pointer to an array of n integers typically
coming from a C function
   cintf converts this integer array into a double array in op 
   moreover, pointer ip is freed */

void C2F(cintf)(n,ip,op)
int *n;
int *ip[];
double *op;
{
  int i;
  if ( *n > 0 ) {
      for (i = 0; i < *n; i++)
	  op[i]=(double)(*ip)[i];
      free((char *)(*ip));
  }
}
