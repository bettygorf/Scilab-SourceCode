/* Copyright INRIA */
#include <string.h>
#include "../machine.h"

/* ip is a pointer to a FORTRAN variable coming from SCILAB
which is itself a pointer to an array of n strings typically
coming from a C function
   cstringf converts this char array into a scilab string matrix
   representation in sciptr
   moreover, pointer ip is freed */

void C2F(cstringf)(ip,sciptr,m,n,max,ierr)
char ***ip;
int *sciptr;
int *m, *n, *max,*ierr;
{
  int i,j,l,ie;
  int job=0;
  int *chars;
  *ierr=0;
  if (5 + *m * *n > *max) {
    *ierr = 1;
    return;
  }
  sciptr[0]=10;
  sciptr[1]=*m;
  sciptr[2]=*n;
  sciptr[3]=0;
  sciptr[4]=1;
  chars=&(sciptr[5 + *m * *n]);
  ie=0;
  for (j = 0; j < *n; j++) {
    for (i = 0; i < *m; i++) {
      l=strlen((*ip)[ie]);
      sciptr[ie+5]=sciptr[ie+4]+l;
      if (5 + *m * *n + sciptr[ie+5] > *max) {
        *ierr = 1;
        return;
      }
      F2C(cvstr)(&l,&(chars[sciptr[ie+4]-1]),(*ip)[ie],&job,l);
      free((*ip)[ie]);
      ie++;
    }
  }
  free((char *)*ip);
}
