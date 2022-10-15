function [f1]=%rmp(f1,n2)
// r=%rmp(f1,n2)  <=> r=f1*n2
// f1=rational n2=polynomial
//!
[n1,d1]=f1(2:3),
[l1,m1]=size(n1);[l2,m2]=size(n2),
//
if mini([l1*m1,l2*m2])=1 then,
  num=n1*n2,
  den=d1*ones(l2,m2),
else,
  if m1<>l2 then error(10),end,
  for i=1:l1,
    n=n1(i,:);
    [y,fact]=lcm(d1(i,:)),
    den(i,1:m2)=ones(1,m2)*y,
      for j=1:m2,
        num(i,j)=n*(n2(:,j).*matrix(fact,l2,1)),
      end,
  end,
end,
[num,den]=simp(num,den),
f1(2)=num;f1(3)=den;



