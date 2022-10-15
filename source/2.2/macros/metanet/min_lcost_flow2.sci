function [c,phi,flag]=min_lcost_flow2(g)
[lhs,rhs]=argn(0)
if rhs<>1 then error(39), end
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
  error('min_lcost_flow2: minimum capacities must be equal to zero')
end
verif=find(maxcap<0) 
if verif<>[] then 
  error('min_lcost_flow2: maximum capacities must be non negative')
end
if or(maxcap<>round(maxcap)) then
  error('min_lcost_flow2: maximum capacities must be integer')
end
// check costs
costs=g('edge_cost')
if costs==[] then
  costs=zeros(1,ma)
end
if or(costs<>round(costs)) then
  error('min_lcost_flow2: costs must be integer')
end
// check demand
demand=g('node_demand')
if demand==[] then
  demand=zeros(1,ma)
end
if or(demand<>round(demand)) then
  error('min_lcost_flow2: demands must be integer')
end
if sum(demand)<>0 then
  error('min_lcost_flow2: sum of demands must be equal to zero')
end
// compute linear min cost flow by relaxation method (Bertsekas)
[c,phi,flag]=relax(g('head'),g('tail'),costs,maxcap,demand,g('arc_number'),n)
