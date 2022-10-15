function [h]=time_id(n,u,y)
npt=prod(size(y));y=matrix(y,npt,1)
m(npt-1,2*n)=0;
select type(u)
case 1 then
  u=matrix(u,npt,1)
pause
  for k=1:n,m(k:npt-1,[k k+n])=[-y(1:npt-k) u(1:npt-k)];end
case 10 then
  select part(u,1)
  case 'i' then
    for k=1:n,m(k:npt-1,[k k+n])=[-y(1:npt-k) eye(npt-k,1)];end
  case 's' then
    for k=1:n,m(k:npt-1,[k k+n])=[-y(1:npt-k) ones(npt-k,1)];end;
  else
     error(' time_id: waiting for ''i'' or ''s'' ')
  end;
else
     error(' time_id: waiting for ''i'' or ''s'' ')
end
 
//
coef=m\y(2:npt);
//
num=poly(coef(2*n:-1:n+1),'z','c');
den=poly([coef(n:-1:1);1],'z','c');
h=list('r',num,den,'d')


