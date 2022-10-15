function h=%rvs(h1,h2)
// %rvs(h1,h2)=(I+h1*h2)\h1. h1: rational
// h2 constant
//!
[m1,n1]=size(h1(2))
[m2,n2]=size(h2)
if abs(n1-m2)+abs(m1-n2)<>0 then error('inconsistent dimensions'),end
if m1*n1==1 then
  h=h1;h(3)=h1(2)*h2+h1(3);
else
  h=(eye(m1,m1)+h1*h2)\h1
end



