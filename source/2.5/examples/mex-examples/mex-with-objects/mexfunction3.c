#include "mex.h"

void mexfunction3(nlhs, plhs, nrhs, prhs)
     int nlhs, nrhs;
     Matrix *plhs[]; Matrix *prhs[];
     /*  A*B  via SCILAB */
{
    Matrix *fplhs[2]; Matrix *fprhs[2];
    int mlhs,mrhs;
    if (nrhs!=2) mexErrMsgTxt("This function requires 2 inputs!");
    if (nlhs >1) mexErrMsgTxt("This function requires 1 output!");
    mlhs=1;mrhs=2;
    fprhs[0]=prhs[0];fprhs[1]=prhs[1];
    mexCallSCILAB(mlhs,fplhs,mrhs,fprhs,"*");
    plhs[0]=fplhs[0];
}  

