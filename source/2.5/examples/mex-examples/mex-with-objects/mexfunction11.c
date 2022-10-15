#include "mex.h"
#include <stdio.h>

void mexfunction11(nlhs, plhs, nrhs, prhs)
     int nlhs, nrhs;
     Matrix *plhs[]; Matrix *prhs[];
{   
  /* Test function: mexfunction11()  */
  Matrix *ptrB;
  double *B;
  int m=1,n=1,it=0;

  if (nrhs != 0) mexErrMsgTxt("Invalid number of inputs!");
  mexEvalString("A11=[1,2,3,4];");
  return ;
}

