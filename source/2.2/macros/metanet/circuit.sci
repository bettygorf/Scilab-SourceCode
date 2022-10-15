function [p,r]=circuit(g)
[lhs,rhs]=argn(0)
if rhs<>1 then error(39), end
// check g
check_graph(g)
// compute lp, la and ls
n=g('node_number')
ma=g('edge_number')
if g('directed')==1 then
  [lp,la,ls]=ta2lpd(g('tail'),g('head'),n+1,n)
else
  error('circuit: the graph must be directed')
end
// compute rank function
[i,r]=frang(lp,ls,n)
if i==0 then p=[]
else p=prevn2p(i,i,r,la,lp,ls,g('directed')), r=[]
end
