clear;lines(0);
s=poly(0,'s');
p=[s;s*(s+1)^2;2*s^2+s^3];
[Y,rk,ac]=colcompr(p*p');
p*p'*Y
