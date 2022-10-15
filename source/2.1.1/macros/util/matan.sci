function x=matan(a)
//   matan - computes the matrix arctangeant
//%CALLING SEQUENCE
//   x=matan(a)
//%PARAMETERS
//   a   : square hermitian matrix
//   x   : square hermitian matrix
//%DESCRIPTION
//   This macro is called by the function atan to compute square matrix 
//   arctangeant
//!
[m,n]=size(a)
if m<>n then error(20,1),end
if a<>a' then error('Non hermitian matrix'),end
r=and(imag(a)==0)
[u,s]=schur(a)
x=u*diag(atan(diag(s)))*u'
if r then x=real(x),end
//end
