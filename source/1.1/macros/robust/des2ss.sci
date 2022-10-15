function [S1]=des2ss(A,B,C,D,E,tol)
//Descriptor to state-space
//!
[LHS,RHS]=argn(0)
if RHS=1 then
 [A,B,C,D,E]=des(2:6);
 if norm(D,1)<>0 then warning('des2ss: D matrix must be zero!');end
 [Bfs,Bis,chis]=glever(E,A);
 S1=C*tf2ss(Bfs/chis)*B;S1(5)=-C*bis*B;
return;
end
if rhs = 5 then tol=1.e-8;end
[ns,ns] = size(a);
if norm(e,1) < %eps then S1=syslin([],0*A,0*B,0*C,-C/A*B + D);return;end
[ue,se,ve,rk] = svd(E,tol*norm(e,1));
k=ns-rk;
if k=0 then Ei=inv(E),S1=syslin([],Ei*A,Ei*B,C,D),return,end
u1 = ue(:,1:ns-k); u2 = ue(:,ns-k+1:ns);
v1 = ve(:,1:ns-k); v2 = ve(:,ns-k+1:ns);
if k=0 then u2=1,v2=1;end
sei = inv(se(1:ns-k,1:ns-k));
a11 = u1'*a*v1;
a12 = u1'*a*v2;
a21 = u2'*a*v1;
a22i = inv(u2'*a*v2);
bb1 = u1'*b;
bb2 = u2'*b;
cc1 = c*v1;
cc2 = c*v2;
aa = sei * (a11 - a12*a22i*a21);
bb = sei * (bb1  - a12*a22i*bb2);
cc = cc1 - cc2 * a22i * a21;
dd = d - cc2 * a22i * bb2;
S1=syslin([],AA,BB,CC,DD);


