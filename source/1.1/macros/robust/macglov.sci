function [P,r]=Macglov(Sl)
//[P,r]=Macglov(Sl)
//Standard plant for the Glover-McFarlane problem:
// for this problem mu_optimal = 1-hankel_norm([N,M])
// with [N,M]=LCF(Sl) (Normalized coprime factorization)
// gama_optimal = 1/sqrt(mu_optimal)
//!
//FD.
flag=0;
if Sl(1)='r' then sl=tf2ss(sl),flag=1;end
[A,B,C,D]=Sl(2:5);[n,nb]=size(B);[nc,n]=size(C);
r=size(D);
[Z,H]=GFARE(Sl);
R1=eye+D*D';
R12=sqrt(R1);
Ap=A;
Bp=[-H*R12,B];
Cp=[C;0*ones(nb,n);C];
Dp=[R12,0*C*B;
    0*ones(nb,nc),eye(nb,nb);
    R12,D];
P=syslin('c',Ap,Bp,Cp,Dp);
if flag=1 then P=ss2tf(P);end



