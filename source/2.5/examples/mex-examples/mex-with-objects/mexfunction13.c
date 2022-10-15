#include "mex.h"
#include <stdio.h>

void mexfunction13(nlhs, plhs, nrhs, prhs)
     int nlhs, nrhs;
     Matrix *plhs[]; Matrix *prhs[];
{ 
  /* Test function: mexfunction10()  */
  char message[56];
  char varname[]="X";
  mxArray *array_ptr;
  int m,n;
  if (nrhs != 0) mexErrMsgTxt("Invalid number of inputs!");
  if (nlhs > 1) mexErrMsgTxt("Invalid number of outputs!");
  mexEvalString("X=[1,2,3];");
  array_ptr = mexGetArray(varname,"base");
  if ( array_ptr == NULL) 
    {
      sprintf(message,"variable %s not found",varname);
    }
  else 
    {
      m = mxGetM(array_ptr);
      n = mxGetN(array_ptr);
      sprintf(message,"variable %s found size=[%d,%d]",varname,m,n);
    }
  plhs[0]=mxCreateString(message);
}
