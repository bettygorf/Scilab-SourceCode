/* Copyright INRIA */
#include <string.h>

#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include "../machine.h"

C2F(stringc)(sciptr,cptr,ierr)
     int *sciptr;
     char ***cptr;
     int *ierr;
{
  char **strings,*p;
  int li,ni,*SciS,i,nstring,*ptrstrings;
  
  *ierr=0;
  nstring=sciptr[1]*sciptr[2];
  strings=(char **) malloc((unsigned) (nstring * sizeof(char *)));
  if (strings==0) {
    *ierr=1; return;
  }
  li=1;
  ptrstrings=&(sciptr[4]);
  SciS=&(sciptr[5+nstring]);
  for ( i=1 ; i<nstring+1 ; i++) 
    {
      ni=ptrstrings[i]-li;
      li=ptrstrings[i];
      ScilabStr2C(&ni,SciS,&p,ierr);
      strings[i-1]=p;
      if ( *ierr == 1) return;
      SciS += ni;
    }
  *cptr=strings;
}
