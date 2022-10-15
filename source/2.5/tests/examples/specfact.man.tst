clear;lines(0);
A=diag([-1,-2]);B=[1;1];C=[1,1];D=1;s=poly(0,'s');
W1=syslin('c',A,B,C,D);
phi=gtild(W1,'c')+W1;
phis=clean(ss2tf(phi))
clean(phis-horner(phis,-s)');   //check this is 0...
[A,B,C,D]=abcd(W1);
[W0,L]=specfact(A,B,C,D);
W=syslin('c',A,B,L,W0)
Ws=ss2tf(W);
horner(Ws,-s)*Ws
