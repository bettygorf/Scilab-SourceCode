function s1=%rmr(s1,s2)
//s1=s1*s2
//!
[s1,s2]=sysconv(s1,s2),
[n1,d1]=s1(2:3);[n2,d2]=s2(2:3);
[l1,m1]=size(n1);[l2,m2]=size(n2),
if mini([l1*m1,l2*m2])=1 then,
  [n1,d1]=simp(n1*n2,d1*d2),
  s1(2)=n1;s1(3)=d1;
  return,
end;
if m1<>l2 then 
  error(10)
end,
for i=1:l1, pp(i)=lcm(d1(i,:)),end,
for j=1:m2,
  y=lcm(d2(:,j)),
  for i=1:l1,
    yij=y*pp(i),
    x=0;
    for k=1:m1,
      x=x+n1(i,k)*n2(k,j)*pppdiv(y,d2(k,j))*pppdiv(pp(i),d1(i,k)),
    end,
    num(i,j)=x,den(i,j)=yij,
  end,
end,
[num,den]=simp(num,den),
s1(2)=num;s1(3)=den;
//end


