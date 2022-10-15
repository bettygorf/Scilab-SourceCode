function x=mpow(a,p)
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
flag=or(a<>a')
if ~flag then 
  //Hermitian matrix
  r=and(imag(a)==0)
  [u,s]=schur(a);
  w=diag(s);
  x=u*diag(exp(p*log(w)))*u';
  if r then
    if s>=0&imag(p)==0 then
      x=real(x)
    end
  end
end
if flag then
 //General matrix
a=a+0*%i;   //Set complex
  r=and(imag(a)==0)
[s,u,bs]=bdiag(a);w=diag(s);
  if maxi(bs)>1 then
    error('mpow: unable to diagonalize!');return
  end
  x=u*exp(p*diag(log(w)))*inv(u);
end

