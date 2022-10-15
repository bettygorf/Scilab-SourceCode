clear;lines(0);
s=poly(0,'s');
p=[s,s*(s+1)^2,s^2*(s+2)];
[pp,fact]=lcm(p);
p.*fact, pp
