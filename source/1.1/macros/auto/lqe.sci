function [K,X]=lqe(P21)
[A,B1,C2,D21,xo,dom]=P21(2:7)
[kk,x]=lqr(syslin(dom,A',c2',b1',d21'));
k=kk';
