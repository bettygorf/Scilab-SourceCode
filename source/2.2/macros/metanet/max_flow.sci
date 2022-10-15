function [v,phi]=max_flow(i,j,g,phi)
[lhs,rhs]=argn(0)
// check i and j
if prod(size(i))<>1 then
  error('max_flow: first argument must be a scalar')
end
if prod(size(j))<>1 then
  error('max_flow: second argument must be a scalar')
end
// check g
check_graph(g)
if g('directed') <> 1 then
  error('max_flow: the graph must be directed')
end
ma=g('edge_number')
n=g('node_number')
// check phi
if rhs=3 then 
  phi=zeros(1,ma)
else
  if rhs<>4 then error(39), end
end
s=size(phi)
if s(1)<>1|s(2)<>ma then
  error('max_flow: initial flow ""phi"" must be a row vector of size '+string(ma))
end
// compute lp, la and ls
[lp,la,ls]=ta2lpd(g('tail'),g('head'),n+1,n)
// check capacities
mincap=g('edge_min_cap')
maxcap=g('edge_max_cap')
if mincap==[] then
  mincap=zeros(1,ma)
end
if maxcap==[] then
  maxcap=zeros(1,ma)
end
ldif=find(mincap>maxcap)
if ldif<>[] then
  error('max_flow: maximum capacities must be greater than minimal capacities')
end
// check initial compatible flow
lcomp=find(phi<mincap)
if lcomp<>[] then
  error('max_flow: initial flow ""phi"" is not between capacities')
end
lcomp=find(phi>maxcap)
if lcomp<>[] then
  error('max_flow: initial flow ""phi"" is not between capacities')
end
u=sparse([g('tail')' [1:ma]'],ones(ma,1),[n;ma])
v=sparse([g('head')' [1:ma]'],-1*ones(ma,1),[n;ma])
a=u+v
if norm(a*phi') > 10**(-10) then
   error('max_flow: initial flow ""phi"" is not compatible') 
end
// compute maximum flow
[v,phi]=flomax(i,j,la,lp,g('head'),g('tail'),mincap,maxcap,n,phi)
