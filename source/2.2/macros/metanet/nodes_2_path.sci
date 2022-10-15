function p=nodes_2_path(ns,g)
[lhs,rhs]=argn(0)
if rhs<>2 then error(39), end
// check ns
s=size(ns)
if s(1)*s(2) == 0 then p=[]; return end
if s(1)<>1 then
  error('nodes_2_path: first argument must be a row vector')
end
if (s(1)*s(2)==1) then
  error('nodes_2_path: first argument must be vector with at least 2 elements')
end
// check g
check_graph(g)
// compute lp, la and ls
ma=g('edge_number')
n=g('node_number')
if g('directed') == 1 then
  [lp,la,ls]=ta2lpd(g('tail'),g('head'),n+1,n)
else
  [lp,la,ls]=ta2lpu(g('tail'),g('head'),n+1,n,2*ma)
end
// compute path
p=ns2p(ns,la,lp,ls,n)
