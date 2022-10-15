function f=%r_j_s(f,s)
// %r_j_s(p,s)  computes p.^s for p rational matrix 
//!
// Copyright INRIA
if s==[] then f=[],return,end
if  or(imag(s)<>0)|or(int(s)<>s) then error('%pjs: integer power only'),end
[m,n]=size(f)
[ms,ns]=size(s)
if ms==1&ns==1 then
  if s<0 then 
    num=f(2)
    if or(abs(coeff(num(:)))*ones(maxi(degree(num))+1,1)==0) then
      error(27)
    end
    s=-s
    f(2)=f(3).^s
    f(3)=num.^s
  else 
    f(2)=f(2).^s
    f(3)=f(3).^s
  end
elseif m==1&n==1 then // Element wise exponentiation f.^s with f "scalar"
  kp=find(s>=0)
  kn=find(s<0)
  num=ones(s)
  den=ones(s)
  num(kp)=f(2).^s(kp)
  den(kp)=f(3).^s(kp)
  p=1/f
  num(kn)=p(2).^(-s(kn))
  den(kn)=p(3).^(-s(kn))
  f=tlist(['r','num','den','dt'],num,den,[])
elseif ms==m&ns==n then  // Element wise exponentiation
  s=s(:);
  kp=find(s>=0)
  kn=find(s<0)
  num=f(2);num=num(:)
  den=f(3);den=den(:)
  num(kp)=num(kp).^s(kp)
  den(kp)=den(kp).^s(kp)

  if or(abs(coeff(num(kn)))*ones(maxi(degree(num(kn)))+1,1)==0) then
    error(27)
  end
  num(kn)=den(kn).^(-s(kn))
  den(kn)=num(kn).^(-s(kn))
  f=tlist(['r','num','den','dt'],matrix(num,n,m),matrix(den,n,m),[])
else
  error(30)
end
    


