function [f]=%rar(s1,s2)
// f= s1+s2
//!
[s1,s2]=sysconv(s1,s2),
[num1,den1]=s1(2:3);
[num2,den2]=s2(2:3);
[n1,n2]=size(num1);[m1,m2]=size(num2);
if (m1<>n1)|(m2<>n2) then
error('dimensions do not agree!');end
for l=1:n1,
  for k=1:n2,
    [den,fact]=lcm([den1(l,k);den2(l,k)])
    num1(l,k)=[num1(l,k),num2(l,k)]*fact
    den1(l,k)=den
  end,
end,
[num1,den1]=simp(num1,den1),
f=list('r',num1,den1,s1(4)),



