clear;lines(0);
s=poly(0,'s');
H=[2/s,(s+1)/(s^2-5)];
Sys=tf2ss(H)
clean(ss2tf(Sys))
