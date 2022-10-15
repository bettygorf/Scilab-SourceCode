function slc=contrss(a,tol)
[lhs,rhs]=argn(0)
//
 if a(1)<>'lss' then
     error(91,1),
 end;
if rhs==1 then tol=sqrt(%eps);end
if rhs>2 then error('1 or 2 inputs to contrss : sl [,tol]')
 end;
 [a,b,c,d,x0,dom]=a(2:7)
//
[nc,u]=contr(a,b,tol)
u=u(:,1:nc)
a=u'*a*u;b=u'*b;c=c*u
slc=tlist('lss',a,b,c,d,u'*x0,dom)




