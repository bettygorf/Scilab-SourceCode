function [c,phi,v,flag]=min_lcost_cflow(i,j,cv,g)
[lhs,rhs]=argn(0)
if rhs<>4 then error(39), end
// check i and j
if prod(size(i))<>1 then
  error('min_lcost_cflow: first argument must be a scalar')
end
if prod(size(j))<>1 then
  error('min_lcost_cflow: second argument must be a scalar')
end
// check cv
if prod(size(cv))<>1 then
  error('min_lcost_cflow: third argument (constrained cost) must be a scalar')
end
if cv<0 then
  error('min_lcost_cflow: constrained cost must be positive')
end
// check g
check_graph(g)
// check capacities
ma=g('edge_number')
n=g('node_number')
mincap=g('edge_min_cap')
maxcap=g('edge_max_cap')
if mincap==[] then
  mincap=zeros(1,ma)
end
if maxcap==[] then
  maxcap=zeros(1,ma)
end
verif=find(mincap<>0)
if verif<>[] then 
  error('min_lcost_cflow: minimum capacities must be equal to zero')
end
verif=find(maxcap<0) 
if verif<>[] then 
  error('min_lcost_cflow: maximum capacities must be non negative')
end
if or(maxcap<>round(maxcap)) then
  error('min_lcost_cflow: maximum capacities must be integer')
end
// check costs
costs=g('edge_cost')
if costs==[] then
  costs=zeros(1,ma)
end
verif=find(costs<0) 
if verif<>[] then 
  error('min_lcost_cflow: costs must be non negative')
end
// check demand
demand=g('node_demand')
if demand==[] then
  demand=zeros(1,ma)
end
verif=find(demand<>0)
if verif<>[] then 
  error('min_lcost_cflow: demands must be equal to zero')
end
// compute lp, la and ls
if g('directed')==1 then
  [lp,la,ls]=ta2lpd(g('tail'),g('head'),n+1,n)
else
  [lp,la,ls]=ta2lpu(g('tail'),g('head'),n+1,n,2*ma)
end
// compute constrained min cost flow by Busacker and Goven algorithm
[v,phi,flag]=busack(i,j,cv,maxcap,g('head'),g('tail'),la,lp,n,costs)
c=costs*phi'
