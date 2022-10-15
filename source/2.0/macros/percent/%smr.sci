function [f2]=%smr(n1,f2)
// %smr(n1,f2)  
//operation  f2=n1*f2
//!
[n2,d2]=f2(2:3);
[l1,m1]=size(n1);[l2,m2]=size(n2),
if mini([l1*m1,l2*m2])=0 then, f2=[];return;end
//
if mini([l1*m1,l2*m2])=1 then,
  num=n1*n2,
  den=ones(l1,m1)*d2,
else,
 if m1<>l2 then error(10),end,
  for j=1:m2,
    [y,fact]=lcm(d2(:,j)),
    n2(:,j)=n2(:,j).*fact,
    den(1:l1,j)=ones(l1,1)*y,
    for i=1:l1,
      num(i,j)=n1(i,:)*n2(:,j),
    end,
  end,
end,
[num,den]=simp(num,den),
f2(2)=num,f2(3)=den;



