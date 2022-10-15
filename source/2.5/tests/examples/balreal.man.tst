clear;lines(0);
A=diag([-1,-2,-3,-4,-5]);B=rand(5,2);C=rand(1,5);
sl=syslin('c',A,B,C);
[slb,U]=balreal(sl);
Wc=clean(ctr_gram(slb))
W0=clean(obs_gram(slb))
