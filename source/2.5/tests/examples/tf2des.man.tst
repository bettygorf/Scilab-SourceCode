clear;lines(0);
s=poly(0,'s');
G=[1/(s-1),s;1,2/s^3];
S1=tf2des(G);des2tf(S1)
S2=tf2des(G,"withD");des2tf(S2)
