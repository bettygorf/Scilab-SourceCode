function [N,M]=lcf(Sl)
//Compute Normalized coprime factorization of a linear dynamic system
//%Syntax and parameters description
//     [N,M]=lcf(Sl)
//
//  SL  : linear dynamic system given in state space or transfer function.
//       see syslin
//  N,M : is realization of Sl: Sl = M^-1 N
//!
//FD.
flag=0;
if Sl(1)='r' then Sl=tf2ss(Sl),flag=1;end
[A,B,C,D]=Sl(2:5);[nw,nb]=size(B);[nc,nw]=size(C);
R=eye+D*D';
[Z,H]=gfare(Sl);
Ar=A+H*C;
Bn=B+H*D;Bm=H;
Rm12=inv(sqrt(R));
Cr=Rm12*C;Dn=Rm12*D;Dm=Rm12;
N=syslin('c',Ar,Bn,Cr,Dn);
M=syslin('c',Ar,Bm,Cr,Dm);
if flag=1 then N=ss2tf(N);M=ss2tf(M);end




