function [S]=ss2des(Sl)
// Returns S=list('d',A,B,C,0,E) for Sl a state-space
// system with Ds polynomial.
Ds=Sl(5);
if type(Ds)==1 then
  if norm(Ds,1)=0 then S=Sl;return;end
  if norm(Ds,1)<>0 then Sl(5)=Ds+poly(0,'s')*0*Ds;end
end
[A2,B2,C2,Ds]=Sl(2:5);
[N,B1,C1]=pol2des(Ds);
[n1,n1]=size(N);
[n2,n2]=size(A2);
E=[N,0*ones(n1,n2);0*ones(n2,n1),eye(n2,n2)];
A=[eye(N),0*ones(n1,n2);0*ones(n2,n1),A2];
C=[C1,C2];
B=[B1;B2];
D=0*C*B;
S=list('d',A,B,C,D,E);
