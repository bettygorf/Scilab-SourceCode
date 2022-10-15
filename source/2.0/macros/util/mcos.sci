function x=mcos(a)
//   mcos - computes the matrix cosine 
//%CALLING SEQUENCE
//   x=mcos(a)
//%PARAMETERS
//   a   : square hermitian matrix
//   x   : square hermitian matrix
//%DESCRIPTION
//This macro is called by the function cos to compute square matrix cosine
//!
[m,n]=size(a)
if m<>n then error(20,1),end
if a<>a' then error('Non hermitian matrix'),end
r=and(imag(a)==0)
[u,s]=schur(a)
x=u*diag(cos(diag(s)))*u'
if r then x=real(x),end

