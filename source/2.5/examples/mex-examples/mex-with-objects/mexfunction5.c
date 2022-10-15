#include "mex.h"

static void dcopytest _PARAMS((int n,double *,double *));

void mexfunction5(nlhs, plhs, nrhs, prhs)
     int nlhs, nrhs;
     Matrix *plhs[]; Matrix *prhs[];
     /*  call fortran dcopy function */
{
  double *v; double *w;
  int m,n;
  v= mxGetPr(prhs[0]);
  m= mxGetM(prhs[0]);
  n= mxGetN(prhs[0]);
  plhs[0]= mxCreateFull(m,n,0);
  w= mxGetPr(plhs[0]);
  dcopytest(m*n,v,w);
} 

void dcopytest(n,v,w) 
     int n;
     double v[],w[];
{
  int i;
  for (i=0; i < n ; i++) w[i]=v[i];
}

 
