function [Bfs,Bis,tf]=des2tf(des)
[LHS,RHS]=argn(0);
if LHS<>1 & LHS<> 3 then error('des2tf: 1 or 3 output args needed');end
A=des(2);B=des(3);C=des(4);E=des(6);
if norm(des(5),1) > 100*%eps then 
warning('des2tf: D matrix is assumed to be 0!');end
s=poly(0,'s')
[Bfs,Bis,chis]=glever(E,A);
if LHS==3 then Bfs=C*Bfs*B; Bis=C*Bis*B;tf=chis;return;end
if LHS==1 then ww=C*Bfs*B;Bfs=ww/chis-c*Bis*b;return;end
