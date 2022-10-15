function [n,u,sl]=dt_ility(sl,tol)
//!
[lhs,rhs]=argn(0)
if type(sl)<>15 then error(91,1),end
if sl(1)<>'lss' then error(91,1),end
[a,b,c,d,x0,dom]=sl(2:7)
select dom
 case 'c' then typ='c'
 case 'd' then typ='d'
 case [] then typ='c';warning('dt_ility-->sl assumed continuous!');
 else typ='d'
end;
[na,nb]=size(b)
//
if rhs=1 then [a,c,u,n]=contr(a',c');
         else [a,c,u,n]=contr(a',c',tol);
end;
a=a';c=c';n=sum(n);
if lhs=3 then b=u'*b;x0=u'*x0;end
if n<>na then
//
  nn=n+1:na
  [v,n1]=schur(a(nn,nn),part(typ,1))
  n=n+n1
//
  if lhs>1 then
        u(:,nn)=u(:,nn)*v
        if lhs=3 then
            a(:,nn)=a(:,nn)*v;a(nn,nn)=v'*a(nn,nn)
            b(nn,:)=v'*b(nn,:)
            c(:,nn)=c(:,nn)*v
            x0(nn)=v'*x0(nn)
        end;
  end;
end;
//
if lhs=3 then sl=list('lss',a,b,c,d,x0,dom),end



