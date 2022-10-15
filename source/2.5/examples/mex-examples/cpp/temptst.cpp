extern "C" {
#include <mex.h>
}
#include "temptst.h"


extern N1<double> callsquare(N1<double> n1);

extern "C" {
  void mexFunction(int nlhs, Matrix** plhs, int nrhs, Matrix** prhs) {
    if (nrhs < 1)
      mexErrMsgTxt("Need at least one argument");
    if (mxGetM(prhs[0]) == 0)
      mexErrMsgTxt("First argument must have at least one entry");
    double* m = mxGetPr(prhs[0]);
    
    N1<double> ans = callsquare(N1<double>(*m));
    Matrix* result = mxCreateFull(1,1,REAL);
    *mxGetPr(result) = ans.data();
    plhs[0] = result;
    return;
  } 
}

