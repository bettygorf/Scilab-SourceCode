function b=%s_l_r(a,b)
// a\b a scalar matrix, b rational matrix
//!
// Copyright INRIA
if  size(a,'*')==0  then b=[],return,end
[num,den]=b(2:3);
[mb,nb]=size(num);mb=abs(mb);nb=abs(nb);
[ma,na]=size(a);na=abs(na);ma=abs(ma);
if ma==1&na==1 then 
  b(2)=a\b(2),
  return,
end
if mb==1 then
  num=a\num
  den=ones(na,ma)*den
  b(2)=num;b(3)=den
else
  dd=[];nn=[]
  for j=1:nb,
    [y,fact]=lcm(den(:,j)),
    nn=[nn,a\(num(:,j).*fact)];
    dd=[dd y]
  end
  [num,den]=simp(nn,ones(na,1)*dd)
  b(2)=num;b(3)=den
end
