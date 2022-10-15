/* Copyright INRIA */
#include "ex5.h"

int CFuncEx(x,nx,y,ny,z,f)
     double *x,*y,*z;
     int nx,ny;
     funcex f;
{
  double res;
  int i,j;
  for ( i = 0 ; i < nx ; i++ ) 
    for ( j = 0 ; j < ny ; j++) 
	(*f)(x[i],y[j],&z[i+nx*j]);
}

  
int fp1(x,y,z) 
     double x,y,*z;
{
  *z= x+y;
}

int fp2(x,y,z) 
     double x,y,*z;
{
  *z= x*x+y*y;
}

