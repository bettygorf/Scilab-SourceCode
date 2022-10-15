function X=mpow(A,p)
//   mpow - A^p
//%CALLING SEQUENCE
//   X=mpow(A)
//%PARAMETERS
//   A   : square hermitian matrix
//   X   : square hermitian matrix
//%DESCRIPTION
//This macro is called by the operation ^ to compute A^p
//!
[m,n]=size(a)
if m<>n then error(20,1),end
if a<>a' then error('Non hermitian matrix'),end
r=and(imag(a)==0)
[u,s]=schur(a)
x=u*diag((diag(s)^p))*u'
if r then
  if s>=0&imag(p)==0 then
    x=real(x)
   end
end
