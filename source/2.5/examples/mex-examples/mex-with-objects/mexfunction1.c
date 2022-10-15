#include "mex.h"
#include <stdio.h>

#define STRING "hello world"

void ABcopy _PARAMS((double *a,double *b,int mn));

void mexfunction1(nlhs, plhs, nrhs, prhs)
     int nlhs, nrhs;
     Matrix *plhs[]; Matrix *prhs[];
{
    Matrix *ptrA,*ptrB;
    double *A,*B;
    int m,n,it,strl;
    char *str;
    double *header;
    mexWarnMsgTxt("This function requires 2 inputs");
    if (nrhs!=2) mexErrMsgTxt("This function requires 2 inputs!");
    if (nlhs>3) mexErrMsgTxt("This function requires at most 3 outputs!");
    ptrA = prhs[0];
    if (! mxIsNumeric(prhs[0])) mexErrMsgTxt("First argument must be numeric matrix.");
    if (! mxIsString(prhs[1])) mexErrMsgTxt("Second argument must be a string.");
    m = mxGetM(ptrA);n = mxGetN(ptrA);
    A = mxGetPr(ptrA);
    it=0;
    ptrB = mxCreateFull(n,m,it);
    m = mxGetM(ptrB);n = mxGetN(ptrB);
    B = mxGetPr(ptrB);
    ABcopy(A,B,m*n);
    plhs[0]=prhs[0];
    plhs[1]= ptrB;
    m=mxGetM(prhs[1]);
    strl=mxGetN(prhs[1]);
    str=mxCalloc(m*strl+1,sizeof(char));
    mxGetString(prhs[1],str,m*strl);
    plhs[2]=mxCreateString(str);
}  

void ABcopy(a,b,mn)
     double *a; double *b;
     int mn;
{
  int i;
  for ( i=0 ; i < mn ; i++) 
    {
      b[i] = a[i] + 33.0 +i;
    }
}
