/* Copyright INRIA */
#include <string.h>

#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include "../machine.h"

#include "sparse.h"

#define FREE(x) if (x  != NULL) free((char *) x);

Sparse *NewSparse(it,m,n,nel)
     int *m,*n,*nel,*it;
{
  Sparse *loc;
  loc = (Sparse *) malloc((unsigned) sizeof(Sparse));
  if ( loc == (Sparse *) 0)
    {
      return((Sparse *) 0);
    }
  loc->m = *m;
  loc->n = *n;
  loc->it = *it;
  loc->nel = *nel;
  loc->mnel = (int*) malloc((unsigned) (*m)*sizeof(int));
  if ( loc->mnel == (int *) 0)
    {
      FREE(loc);
      return((Sparse *) 0);
    }
  loc->icol = (int*) malloc((unsigned) (*nel)*sizeof(int));
  if ( loc->icol == (int *) 0)
    {
      FREE(loc->mnel);
      FREE(loc);
      return((Sparse *) 0);
    }
  loc->xr =  (double*) malloc((unsigned) (*nel)*sizeof(double));
  if ( loc->xr == (double *) 0)
    {
      FREE(loc->icol);
      FREE(loc->mnel);
      FREE(loc);
      return((Sparse *) 0);
    }

  if ( *it == 1) 
    {
      loc->xi =  (double*) malloc((unsigned) (*nel)*sizeof(double));
      if ( loc->xi == (double *) 0)
	{
	  FREE(loc->xr);
	  FREE(loc->icol);
	  FREE(loc->mnel);
	  FREE(loc);
	  return((Sparse *) 0);
	}
    }
  return(loc);
}

FreeSparse(x)
     Sparse *x;
{
  if ( x->it == 1 ) FREE(x->xi);
  FREE(x->xr);
  FREE(x->icol);
  FREE(x->mnel);
  FREE(x);
}

/*******************************************
 * intersci external function for sparse 
 *******************************************/

int C2F(csparsef)(x,mnel,icol,xr,xi)
     Sparse **x;
     int *mnel,*icol;
     double *xr,*xi;
{
  int i;
  for ( i=0 ; i < (*x)->m ; i++) 
    mnel[i] = (*x)->mnel[i];
  for ( i=0 ; i < (*x)->nel ; i++) 
    {
      icol[i] = (*x)->icol[i];
      xr[i] = (*x)->xr[i];
      if ( (*x)->it == 1 )xi[i] = (*x)->xi[i];
    }
  FreeSparse(*x);
}



