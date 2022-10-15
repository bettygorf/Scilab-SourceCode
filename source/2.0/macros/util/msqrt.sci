function x=msqrt(a)
//   msqrt - computes the matrix square root. 
//%CALLING SEQUENCE
//   x=msqrt(a)
//%PARAMETERS
//   a   : square hermitian matrix
//   x   : square hermitian matrix
//%DESCRIPTION
//   This macro is called by the function sqrt to compute square matrix
//   square root.
//!
[m,n]=size(a)
if m<>n then error(20,1),end
if a<>a' then error('Non hermitian matrix'),end
r=and(imag(a)==0)
[u,s]=schur(a);s=diag(s)
x=u*diag(sqrt(s))*u'
if r then
  if s>=0 then
    x=real(x)
   end
end
//end
