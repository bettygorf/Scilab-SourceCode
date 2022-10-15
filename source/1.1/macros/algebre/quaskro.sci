function [Q,Z,Ec,Ac,Qd,Zd,numbeps]=quaskro(E,A)
// quasi- Kronecker form: s*Ec - Ac = Q*(sE-A)*Z
//
//             | sE(eps)-A(eps) |        X       |      X     |
//             |----------------|----------------|------------|
//             |        O       | sE(inf)-A(inf) |      X     |
//  Q(sE-A)Z = |=================================|============|
//             |                                 |            |
//             |                O                | sE(r)-A(r) |
//
// Ec=Q*E*Z, Ac=Q*A*Z, eps=Qd(1) x Zd(1) ,inf=Qd(2) x Zd(2)
// r = Qd(3) x Zd(3)
// numbeps(1) = # of eps blocks of size 0 x 1
// numbeps(2) = # of eps blocks of size 1 x 2
// numbeps(3) = # of eps blocks of size 2 x 3     etc...
// interface  from Slicot-fstair (F.D.) 
// T. Beelen's routines
//!
[na,ma]=size(A);
[m,n]=size(E);
Q=eye(na,na);Z=eye(ma,ma);
[E,Q,Z,stair,rk]=ereduc(E,10*%eps*norm(E))
A=Q*A*Z;
tol=100*%eps*maxi([norm(A,'fro'),norm(E,'fro')])+10*%eps;
[Ac,Ec,Q,Z,nlbcks,muk,nuk,muk0,nuk0,mnei]=fstair(A,E,Q,Z,stair,rk,tol)
numbeps=muk0(1:nlbcks)-nuk0(1:nlbcks);
Qd=[mnei(1),mnei(3),na-mnei(1)-mnei(3)];
Zd=[mnei(2),mnei(3),ma-mnei(2)-mnei(3)];

