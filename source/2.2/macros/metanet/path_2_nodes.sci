function ns=path_2_nodes(p,g)
[lhs,rhs]=argn(0)
if rhs<>2 then error(39), end
// check p
s=size(p)
if s(1)*s(2) == 0 then ns=[]; return end
if s(1)<>1 then
  error('path_2_nodes: first argument must be a row vector')
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
// compute node set
ns=p2ns(p,la,lp,ls,g('directed'),n)
