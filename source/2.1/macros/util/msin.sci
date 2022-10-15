function x=msin(a)
//   msin - computes the matrix sine 
//%CALLING SEQUENCE
//   x=msin(a)
//%PARAMETERS
//   a   : square hermitian matrix
//   x   : square hermitian matrix
//%DESCRIPTION
//This macro is called by the function sin to compute square matrix sine
[m,n]=size(a)
if m<>n then error(20,1),end
if a<>a' then error('Non hermitian matrix'),end
[u,s]=schur(a)
x=u*diag(sin(diag(s)))*u'

