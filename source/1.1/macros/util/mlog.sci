function x=mlog(a)
//   mlog - logarithm
//%CALLING SEQUENCE
//   x=mlog(a)
//%PARAMETERS
//   a   : square hermitian matrix
//   x   : square hermitian matrix
//%DESCRIPTION
//This macro is called by the function log to compute square matrix
//neperian logarithm. 
//!
[m,n]=size(a)
if m<>n then error(20,1),end
if a<>a' then error('Non hermitian matrix'),end
r=and(imag(a)==0)
[u,s]=schur(a)
x=u*diag(log(diag(s)))*u'
if r then
  if s>0 then
    x=real(x)
   end
end
