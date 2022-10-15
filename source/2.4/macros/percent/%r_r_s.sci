function a=%r_r_s(a,b)
// a/b a rational matrix, b scalar matrix
//!
// Copyright INRIA
if size(b,'*')==0 then a=[],return,end
[num,den]=a(2:3);
[ma,na]=size(num);
[mb,nb]=size(b);
if mb*nb==1 then 
  a(2)=a(2)/b,
  if ma==-1|mb==-1 then a(3)=a(3)*eye,end
  return,
end
na=abs(na);ma=abs(ma)
mb=abs(mb);nb=abs(nb)
if na==1 then
  num=num/b
  den=ones(nb,mb)*den
  a(2)=num;a(3)=den
else
  dd=[];nn=[]
  for i=1:ma,
    [y,fact]=lcm(den(i,:)),
    nn=[nn;(num(i,:).*fact)/b];
    dd=[dd;y]
  end
  [num,den]=simp(nn,dd*ones(1,mb))
  a(2)=num;a(3)=den
end







