clear;lines(0);
s=poly(0,'s');
Sys=syslin('c',[1,1/(s+1);2*s/(s^2+2),1/s])
ss2tf(dscr(tf2ss(Sys),0.1))
