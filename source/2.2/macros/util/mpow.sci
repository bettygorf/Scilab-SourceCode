function x=mpow(a,p)
//   mpow - A^p
//%CALLING SEQUENCE
//   X=mpow(A)
//%PARAMETERS
//   A   : square hermitian or diagonalizable matrix
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
  zw=find(w==0);
  w(zw)=%eps*ones(zw)';w1=log(w);w1(zw)=-%inf*ones(zw)';
  x=u*diag(exp(p*w1))*u';
  if r then
    if s>=0&imag(p)==0 then
      x=real(x)
    end
  end
end
if flag then
 //General matrix
r=and(imag(a)==0)
a=a+0*%i;   //Set complex
[s,u,bs]=bdiag(a);
  if maxi(bs)>1 then
    error('mpow: unable to diagonalize!');return
  end
  w=diag(s);
    zw=find(w==0);
  w(zw)=%eps*ones(zw)';w1=log(w);w1(zw)=-%inf*ones(zw)';
  x=u*exp(p*diag(w1))*inv(u);
end

