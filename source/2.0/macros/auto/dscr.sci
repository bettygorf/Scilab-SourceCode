function [f,r]=dscr(a,dt,m)
[lhs,rhs]=argn(0);lst=0
select a(1)
     case 'r' then
     error('dscr: state-space only, use tf2ss');
     case 'lss' then
      [a,b,c,d,x0,dom]=a(2:7)
      if dom<>'c' then 
	warning('dscr: time domain assumed to be continuous'),end
     else error(97,1),
end;
[n1,m1]=size(b),
s=exp([a,b;0*ones(m1,n1+m1)]*dt),
f=s(1:n1,1:n1);g=s(1:n1,n1+1:n1+m1);
if rhs=3 then
  s=exp([-a,m;0*a a']*dt),
  r=f*s(1:n1,n1+1:n1+n1),
end;
f=list('lss',f,g,c,d,x0,dt)




