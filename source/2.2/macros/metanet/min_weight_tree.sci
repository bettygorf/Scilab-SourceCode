function t=min_weight_tree(i,g)
[lhs,rhs]=argn(0)
l=34
select rhs
case 1
  if type(i)==16&size(i)==l&i(1)=='graph' then
    g=i
    i=1
  else
    error('min_weigth_tree: first argument must be a number or a graph-list')
  end
case 2 then
  if prod(size(i))<>1 then
    error('min_weigth_tree: first argument must be a number')
  end
else
  error(39)
end
// check g
check_graph(g)
// compute lp, la and ls
n=g('node_number')
ma=g('edge_number')
if g('directed')==1 then
  [lp,la,ls]=ta2lpd(g('tail'),g('head'),n+1,n)
else
  [lp,la,ls]=ta2lpu(g('tail'),g('head'),n+1,n,2*ma)
end
// value of weight
if g('edge_weight')==[] then
  w=zeros(1,ma)
else
  w=g('edge_weight')
end
// compute minimal spanning tree
if g('directed')==1 then
  alf=dmtree(i,la,lp,ls,n,w)
  t=prevn2st(alf,la,lp,ls)
else 
  if ma<0.5*n*n then 
    alf=umtree1(la,lp,ls,n,w)
  else 
    alf=umtree(la,lp,ls,n,w)
  end
  t=edge2st(alf) 
end
