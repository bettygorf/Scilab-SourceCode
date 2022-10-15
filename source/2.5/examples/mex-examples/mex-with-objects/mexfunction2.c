#include "mex.h"
#include <stdio.h>

void mexfunction2(nlhs, plhs, nrhs, prhs)
     int nlhs, nrhs;
     Matrix *plhs[]; Matrix *prhs[];
{   /* Test function */
  int k;
  if (nlhs > nrhs) mexErrMsgTxt("Too many outputs!");
  for (k=0; k < nrhs; k++) plhs[k]=prhs[k];
}
