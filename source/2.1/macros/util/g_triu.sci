function d=g_triu(a,k)
// g_triu - implement triu function for sparse matrix, rationnal matrix ,..
[lhs,rhs]=argn(0)
if rhs==1 then k=0,end
select type(a)
case 1 then
  d=triu(a,k)
case 2 then
  d=triu(a,k)
case 4 then
  [m,n]=size(a)
  if k<=0 then
    mn=mini(m,n-k)
  else
    mn=min(m+k,n)
  end
  a=matrix(a,m*n,1)
  i=(1:mn)+((1:mn)+(k-1))*m
  d=emptystr(m*n,1)
  d(i)=a(i)
  d=matrix(d,m,n)
case 5 then
  [ij,v,sz]=spget(a)
  m=sz(1);n=sz(2)
  l=find(ij(:,1)<=(ij(:,2)-k))
  d=sparse(ij(l,:),v(l),[m,n])
case 6 then
  [ij,v,sz]=spget(a)
  m=sz(1);n=sz(2)
  l=find(ij(:,1)<=(ij(:,2)-k))
  d=sparse(ij(l,:),v(l),[m,n])
case 15 then
  if a(1)=='r' then
    d=a;
    d=list(a(1),triu(a(2),k),triu(a(3),k),a(4))
  end
end
