clear;lines(0);
s=poly(0,'s');
G=[1,s;1+s^2,3*s^3];[N,B,C]=pol2des(G);
G1=clean(C*inv(s*N-eye())*B),G2=numer(G1)
