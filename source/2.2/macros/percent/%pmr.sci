function [f]=%pmr(p,f)
// r=%pmr(p,f)  <=> r= p*f with p=polynomial matrix
// and f= rational
//!
[n2,d2]=f(2:3);
[l1,m1]=size(p);[l2,m2]=size(n2)
//
if mini([l1*m1,l2*m2])=1 then
  num=p*n2,
  den=ones(l1,m1)*d2,
  [num,den]=simp(num,den),
  f(2)=num,
  f(3)=den,
  return,
end;
if m1<>l2 then error(10),end
//
for j=1:m2,
   y=lcm(d2(:,j))
   for i=1:l1,
    x=0;
      for k=1:m1,
        x=x+p(i,k)*pdiv(y,d2(k,j))*n2(k,j),
      end,
    num(i,j)=x,den(i,j)=y,
  end,
end,
[num,den]=simp(num,den)
f(2)=num,f(3)=den;



