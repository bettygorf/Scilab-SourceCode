#include "mex.h"
#include <stdio.h>

/*
 * Test function : Storing a Matrix in Scilab workspace 
 * mexPutFull uses cwritemat 
 */

void mexfunction12(nlhs, plhs, nrhs, prhs)
     int nlhs, nrhs;
     Matrix *plhs[]; Matrix *prhs[];
{  
  /* Test function: mexfunction12()  */
  mxArray *array_ptr;
  int m=4,n=2,it=0,i;
  double *B;
  if (nrhs != 0) mexErrMsgTxt("Invalid number of inputs!");
  array_ptr = mxCreateFull(m,n,it);
  B = mxGetPr(array_ptr);  
  for (i=0 ; i < m*n ;i++ ) B[i]= (double) i;
  mexPutFull("C",&m,&n,B,NULL); 
  mxFree(array_ptr);
}



