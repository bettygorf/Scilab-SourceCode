function x=mlog(a)
//   mlog - log(A)
//%CALLING SEQUENCE
//   X=mlog(A)
//%PARAMETERS
//   A   : square hermitian or diagonalizable matrix
//   X   : square matrix
//%DESCRIPTION
//computes X=mlog(A), matrix log of A
//!
[m,n]=size(a)
if m<>n then error(20,1),end
flag=or(a<>a')
if ~flag then 
//Hermitian matrix
  r=and(imag(a)==0)
  [u,s]=schur(a);  w=diag(s); 
  zw=find(w==0);
  w(zw)=%eps*ones(zw);w1=log(w);w1(zw)=-%inf*ones(zw);
  x=u*diag(w1)*u';
  if r then
    if and(s>=0) then
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
    error('mlog: unable to diagonalize!');return
  end
  w=diag(s);
  zw=find(w==0);
  w(zw)=%eps*ones(zw);w1=log(w);w1(zw)=-%inf*ones(zw);
  x=(u*diag(w1))*inv(u);
end

