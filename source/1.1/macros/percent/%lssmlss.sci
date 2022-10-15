function [SS]=%lssmlss(S1,S2)
//S=%lssmlss(S1,S2)  computes S1*S2 in state-space form.
//  --> S2 --> S1 -->
//!
[s1,s2]=sysconv(s1,s2)
[a1,b1,c1,d1,x1,dom1]=s1(2:7),
[a2,b2,c2,d2,x2]=s2(2:6),
//
if maxi(degree(d1))==0 & maxi(degree(d2))==0 then
  d1=coeff(d1);d2=coeff(d2);
  b1c2=b1*c2
  ss=list('lss',[a1,b1c2;0*b1c2' ,a2],[b1*d2;b2],...
                            [c1,d1*c2],d1*d2,[x1;x2],dom1),
  return
end
//improper systems
s=poly(0,varn(D1*D2));
J=[A1,B1*C2;
   0*ones(B1*C2)',A2];
Ls=[C1 D1*C2]'
Ms=[B1*D2;B2]

if Ms==[]|Ls==[] then
   ss=list('lss',[],[],[],D1*D2,[x1;x2],dom1)
   return;
end
//
deg=maxi(degree(Ms));
B=coeff(Ms,deg);
ps=0*B
for i=1:deg
  ps=s*ps+B
  B=J*B+coeff(Ms,deg-i)
end
//
deg=maxi(degree(Ls));  J=J'
C=coeff(Ls,deg);
pps=0*C
for i=1:deg
  pps=s*pps+C
  C=J*C+coeff(Ls,deg-i)
end
//
C=C';
D=pps'*B+Ls'*Ps+D1*D2;
Dg=maxI(degree(D));
if dg==0 then D=coeff(D);end

SS=list('lss',J',B,C,D,[x1;x2],dom1);
