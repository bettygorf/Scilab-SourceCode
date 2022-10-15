clear;lines(0);
M=[1,2;0,3];
[N,d]=coff(M)
N/d
inv(%s*eye()-M)
