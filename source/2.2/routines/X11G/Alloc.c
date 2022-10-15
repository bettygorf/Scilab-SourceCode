#include <string.h> /* in case of dbmalloc use */

#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include "Math.h"

static unsigned nx,ny,nz;
static integer *xm1,*ym1,*zm1;
static xfirstentry=1,yfirstentry=1,zfirstentry=1;
#define NBPOINTS 256 

integer ReAllocVectorX(xm,n)
     integer n,**xm  ;
{
  while (n > nx)  nx += NBPOINTS ;
  xm1 = (integer *) REALLOC( xm1, nx * sizeof (integer));
  if (xm1 == 0) return (0);
  *xm=xm1;
  return(1);
}

integer AllocVectorX(xm)
     integer **xm  ;
{
  nx = NBPOINTS;
  *xm=xm1 = (integer *) MALLOC(nx * sizeof (integer)); 
  if (xm1 == 0) return(0);
  else return(1);
}

integer ReAllocVectorY(ym,n)
     integer n,**ym  ;
{
  while (n > ny) ny += NBPOINTS ;
  ym1 = (integer *) REALLOC( ym1, ny * sizeof (integer));
  if (ym1 == 0) return (0);
  *ym=ym1;
  return(1);
}

integer AllocVectorY(ym)
     integer **ym  ;
{
  ny = NBPOINTS;
  *ym=ym1 = (integer *) MALLOC(ny * sizeof (integer)); 
  if (ym1 == 0) return(0);
  else return(1);
}


integer ReAllocVectorZ(zm,n)
     integer n,**zm  ;
{
  while (n > nz) nz += NBPOINTS ;
  zm1 = (integer *) REALLOC( zm1,  nz * sizeof (integer));
  if (zm1 == 0) return (0);
  *zm=zm1;
  return(1);
}

integer AllocVectorZ(zm)
     integer **zm  ;
{
  nz = NBPOINTS;
  *zm=zm1 = (integer *) MALLOC(nz * sizeof (integer)); 
  if (zm1 == 0) return(0);
  else return(1);
}

Alloc(xm,ym,zm,xn,yn,zn,err)
     integer **xm,**ym,**zm,*err;
     integer xn,yn,zn;
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
static dzfirstentry=1;

integer ReAllocVectorZD(zm,n)
     integer n;
     double **zm  ;
{
  while (n > nzd) nzd += NBPOINTS ;
  zm1d = (double *) REALLOC( zm1d,  nzd * sizeof (double));
  if (zm1d == 0) return (0);
  *zm=zm1d;
  return(1);
}

integer AllocVectorZD(zm)
    double **zm  ;
{
  nzd = NBPOINTS;
  *zm=zm1d = (double *) MALLOC(nzd * sizeof (double)); 
  if (zm1d == 0) return(0);
  else return(1);
}

AllocD(zm,zn,err)
     double **zm;
     integer zn,*err;
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

/*------------------------END--------------------*/


/*------------------------END--------------------*/

