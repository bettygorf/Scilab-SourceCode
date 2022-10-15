clear;lines(0);
s=poly(0,'s')
a=[ s, s^2+1; s  s^2-1];
[a1,d]=coffg(a);
(a1/d)-inv(a)
