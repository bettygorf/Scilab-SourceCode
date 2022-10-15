function x=msign(a)
//   msign - computes the matrix sign function.
//%CALLING SEQUENCE
//   x=msign(a)
//%PARAMETERS
//   a   : square hermitian matrix
//   x   : square hermitian matrix
//%DESCRIPTION
//   This macro is called by the function sign to compute square matrix
//   sign function.
//!
[m,n]=size(a)
if m<>n then error(20,1),end
flag=or(a<>a');
if flag then error('msign: non hermitian matrix'),end
[u,s]=schur(a)
x=u'*diag(sign(real(diag(s))))*u

