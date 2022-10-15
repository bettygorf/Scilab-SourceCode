#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include "../../../routines/machine.h"
#include <string.h> 
#include <stdio.h>

/*************************************************************
 * Function interfaced in OptTestf.f 
 *************************************************************/

/*     integer array    */

int C2F(f) ( a, ma,na, b,mb,nb,err) 
     int *ma,*na,*mb,*nb,*err;
     double *a,*b;
{
  int i;
  *err=0;
  for ( i= 0 ; i < (*ma)*(*na) ; i++) a[i] = 2*a[i] ;
  for ( i= 0 ; i < (*mb)*(*nb) ; i++) b[i] = 3*b[i] ;
  return(0);
}
