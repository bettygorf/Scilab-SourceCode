function h=%rvr(h1,h2)
// %rvr(h1,h2) calcule (I+h1*h2)\h1. h1 et h2 matrices de fractions
//  rationnelles
//!
[h1,h2]=sysconv(h1,h2),
[m1,n1]=size(h1(2))
[m2,n2]=size(h2(2))
if abs(n1-m2)+abs(m1-n2)<>0 then error('inconsistent dimensions'),end
if m1*n1==1 then
  h=h1;h(2)=h1(2)*h2(3);h(3)=h1(2)*h2(2)+h1(3)*h2(3);
else
  h=(eye(m1,m1)+h1*h2)\h1
end



