function d=g_tril(a,k)
// g_tril - implement tril function for sparse matrix, rationnal matrix ,..
[lhs,rhs]=argn(0)
if rhs==1 then k=0,end
select type(a)
case 1 then
  d=tril(a,k)
case 2 then
  d=tril(a,k)
case 4 then
  [m,n]=size(a)
  i=find(tril(ones(a),k))
  a=matrix(a,m*n,1)
  d=emptystr(m*n,1)
  d(i)=a(i)
  d=matrix(d,m,n)
case 5 then
  [ij,v,sz]=spget(a)
  m=sz(1);n=sz(2)
  l=find(ij(:,1)>=(ij(:,2)-k))
  d=sparse(ij(l,:),v(l),[m,n])
case 6 then
  [ij,v,sz]=spget(a)
  m=sz(1);n=sz(2)
  l=find(ij(:,1)>=(ij(:,2)-k))
  d=sparse(ij(l,:),v(l),[m,n])
case 15 then
  if a(1)=='r' then
    d=a;
    d=list(a(1),tril(a(2),k),tril(a(3),k),a(4))
  end
end
