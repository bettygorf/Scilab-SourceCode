clear;lines(0);
A=diag([-1,-2,-3,-4,-5]);B=rand(5,1);C=rand(1,5);
sl=syslin('c',A,B,C);
slapprox=arhnk(sl,2);
[nk,W]=hankelsv(sl);nk
[nkred,Wred]=hankelsv(slapprox);nkred
