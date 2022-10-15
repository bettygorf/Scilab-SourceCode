#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif

static unsigned nx,ny,nz;
static int *xm1,*ym1,*zm1;
static xfirstentry=1,yfirstentry=1,zfirstentry=1;
#define NBPOINTS 256 

int ReAllocVectorX(xm,n)
     int n,**xm  ;
{
  while (n > nx)  nx += NBPOINTS ;
  xm1 = (int *) realloc ((char *) xm1, (unsigned)nx * sizeof (int));
  if (xm1 == 0) return (0);
  *xm=xm1;
  return(1);
}

int AllocVectorX(xm)
     int **xm  ;
{
  nx = NBPOINTS;
  *xm=xm1 = (int *) malloc ( (unsigned)nx * sizeof (int)); 
  if (xm1 == 0) return(0);
  else return(1);
}

int ReAllocVectorY(ym,n)
     int n,**ym  ;
{
  while (n > ny) ny += NBPOINTS ;
  ym1 = (int *) realloc ((char *) ym1, (unsigned)ny * sizeof (int));
  if (ym1 == 0) return (0);
  *ym=ym1;
  return(1);
}

int AllocVectorY(ym)
     int **ym  ;
{
  ny = NBPOINTS;
  *ym=ym1 = (int *) malloc ( (unsigned)ny * sizeof (int)); 
  if (ym1 == 0) return(0);
  else return(1);
}

int ReAllocVectorZ(zm,n)
     int n,**zm  ;
{
  while (n > nz) nz += NBPOINTS ;
  zm1 = (int *) realloc ((char *) zm1, (unsigned) nz * sizeof (int));
  if (zm1 == 0) return (0);
  *zm=zm1;
  return(1);
}

int AllocVectorZ(zm)
     int **zm  ;
{
  nz = NBPOINTS;
  *zm=zm1 = (int *) malloc ( (unsigned)nz * sizeof (int)); 
  if (zm1 == 0) return(0);
  else return(1);
}


Alloc(xm,ym,zm,xn,yn,zn,err)
     int **xm,**ym,**zm,*err;
     int xn,yn,zn;
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

/*------------------------END--------------------*/

