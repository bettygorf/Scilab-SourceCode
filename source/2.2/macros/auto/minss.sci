function [Slmin]=minss(Sl,tol)
[lhs,rhs]=argn(0)
 if Sl(1)<>'lss' then error(91,1),end
 select rhs
   case 1 then tol=[]
   case 2 then tol=tol
   else error('1 or 2 inputs: sl [,tol]')
 end;
 [a,b,c,d,x0,dom]=Sl(2:7)
//
if tol<>[] then
   [nc,u1]=contr(a',c',tol)
else
   [nc,u1]=contr(a',c')
end
u=u1(:,1:nc)
c=c*u;a=u'*a*u;b=u'*b,x0=u'*x0;
if tol<>[] then
  [no,u2]=contr(a,b,tol)
else
  [no,u2]=contr(a,b)
end
u=u2(:,1:no)
a=u'*a*u;b=u'*b;c=c*u
if lhs=1 then Slmin=tlist('lss',a,b,c,d,u'*x0,dom),end
//Would be nice to return U=U1*U2

