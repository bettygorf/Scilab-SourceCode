#include "mex.h"
#include <stdio.h>

void mexfunction9(nlhs, plhs, nrhs, prhs)
     int nlhs, nrhs;
     Matrix *plhs[]; Matrix *prhs[];
{   /* Test function: mexfunction9() displays A=... */
  Matrix *pplhs[1]; Matrix *pprhs[1];
  int nnlhs, nnrhs;
  if (nrhs != 0) mexErrMsgTxt("Invalid number of inputs!");
  nnlhs=0; nnrhs=1;
  pprhs[0]=mxCreateString("A=[1,2;3,4]");
  mexCallSCILAB(nnlhs, pplhs, nnrhs, pprhs, "disp");
}
