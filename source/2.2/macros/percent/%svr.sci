function h=%svr(h1,h2)
// %svr(h1,h2) calcule (I+h1*h2)\h1. h1 matrice de scalaires, h2 matrice
// de fractions rationnelles
//!
[m1,n1]=size(h1)
[m2,n2]=size(h2(2))
if abs(n1-m2)+abs(m1-n2)<>0 then error('inconsistent dimensions'),end
if m1*n1==1 then
  h=h2;h(2)=h1*h2(3);h(3)=h1*h2(2)+h2(3);
else
  h=(eye(m1,m1)+h1*h2)\h1
end



