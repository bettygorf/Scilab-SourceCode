/* Copyright (C) 1998 Chancelier Jean-Philippe */
#include <string.h> /* in case of dbmalloc use */

#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include "Math.h"

static unsigned nx,ny,nz;
static integer *xm1,*ym1,*zm1;
static int xfirstentry=1,yfirstentry=1,zfirstentry=1;
#define NBPOINTS 256 

integer ReAllocVectorX(xm, n)
     integer **xm;
     integer n;
{
  while (n > (int) nx)  nx += NBPOINTS ;
  xm1 = (integer *) REALLOC( xm1, nx * sizeof (integer));
  if (xm1 == 0) return (0);
  *xm=xm1;
  return(1);
}

integer AllocVectorX(xm)
     integer **xm;
{
  nx = NBPOINTS;
  *xm=xm1 = (integer *) MALLOC(nx * sizeof (integer)); 
  if (xm1 == 0) return(0);
  else return(1);
}

integer ReAllocVectorY(ym, n)
     integer **ym;
     integer n;
{
  while (n > (int) ny) ny += NBPOINTS ;
  ym1 = (integer *) REALLOC( ym1, ny * sizeof (integer));
  if (ym1 == 0) return (0);
  *ym=ym1;
  return(1);
}

integer AllocVectorY(ym)
     integer **ym;
{
  ny = NBPOINTS;
  *ym=ym1 = (integer *) MALLOC(ny * sizeof (integer)); 
  if (ym1 == 0) return(0);
  else return(1);
}


integer ReAllocVectorZ(zm, n)
     integer **zm;
     integer n;
{
  while (n > (int) nz) nz += NBPOINTS ;
  zm1 = (integer *) REALLOC( zm1,  nz * sizeof (integer));
  if (zm1 == 0) return (0);
  *zm=zm1;
  return(1);
}

integer AllocVectorZ(zm)
     integer **zm;
{
  nz = NBPOINTS;
  *zm=zm1 = (integer *) MALLOC(nz * sizeof (integer)); 
  if (zm1 == 0) return(0);
  else return(1);
}

void Alloc(xm, ym, zm, xn, yn, zn, err)
     integer **xm;
     integer **ym;
     integer **zm;
     integer xn;
     integer yn;
     integer zn;
     integer *err;
{
  *err=1;
  /** Allocation  **/
  if ( xn != 0) 
    {
      if ( xfirstentry )
	{
	  *err=AllocVectorX(xm);
	  if (*err != 0) 
	    {
	      xfirstentry=0;
	      *err=ReAllocVectorX(xm,xn);
	    }
	}
      else 
	{
	  *err=ReAllocVectorX(xm,xn);
	}
    }
  if ( yn != 0) 
    {
      if ( yfirstentry )
	{
	  *err=AllocVectorY(ym);
	  if (*err != 0) 
	    {
	      yfirstentry=0;
	      *err=ReAllocVectorY(ym,yn);
	    }
	}
      else 
	{
	  *err=ReAllocVectorY(ym,yn);
	}
    }
  if ( zn != 0) 
    {
      if ( zfirstentry )
	{
	  *err=AllocVectorZ(zm);
	  if (*err != 0) 
	    {
	      zfirstentry=0;
	      *err=ReAllocVectorZ(zm,zn);
	    }
	}
      else 
	{
	  *err=ReAllocVectorZ(zm,zn);
	}
    }
}


static unsigned nzd;
static double *zm1d;
static int dzfirstentry=1;

integer ReAllocVectorZD(zm, n)
     double **zm;
     integer n;
{
  while (n > (int) nzd) nzd += NBPOINTS ;
  zm1d = (double *) REALLOC( zm1d,  nzd * sizeof (double));
  if (zm1d == 0) return (0);
  *zm=zm1d;
  return(1);
}

integer AllocVectorZD(zm)
     double **zm;
{
  nzd = NBPOINTS;
  *zm=zm1d = (double *) MALLOC(nzd * sizeof (double)); 
  if (zm1d == 0) return(0);
  else return(1);
}

void AllocD(zm, zn, err)
     double **zm;
     integer zn;
     integer *err;
{
  *err=1;
  /** Allocation  **/
  if ( zn != 0) 
    {
      if ( dzfirstentry )
	{
	  *err=AllocVectorZD(zm);
	  if (*err != 0) 
	    {
	      dzfirstentry=0;
	      *err=ReAllocVectorZD(zm,zn);
	    }
	}
      else 
	{
	  *err=ReAllocVectorZD(zm,zn);
	}
    }
}


