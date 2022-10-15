clear;lines(0);
s=poly(0,'s');
p=[s, s*(s+1)^2, 2*s^2+s^3];
[Ar,U]=hermit(p'*p);
clean(p'*p*U), det(U)
