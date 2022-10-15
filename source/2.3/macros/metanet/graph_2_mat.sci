function [a]=graph_2_mat(g)
[lhs,rhs]=argn(0)
if rhs<>1 then error(39), end
// g
check_graph(g)
ma=prod(size(g('tail')))
n=g('node_number')
ta=g('tail')'; he=g('head')';
if g('directed') == 1 then
  u=sparse([ta [1:ma]'],ones(ma,1),[n;ma]);
  v=sparse([he [1:ma]'],-1*ones(ma,1),[n;ma]);
else
  u=sparse([ta [1:ma]'],ones(ma,1),[n;ma]);
  v=sparse([he [1:ma]'],ones(ma,1),[n;ma]);
end
a=u+v
