//<h>=%rvp(h1,h2)
// %rvp(h1,h2) calcule (I+h1*h2)\h1. h1: matrice de fractions rationnelles
// h2 matrice de polynomes
//!
[m1,n1]=size(h1(2))
[m2,n2]=size(h2)
if abs(n1-m2)+abs(m1-n2)<>0 then error('inconsistent dimensions'),end
h=(eye(m1,m1)+h1*h2)\h1
//end

