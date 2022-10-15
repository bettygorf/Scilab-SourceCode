function [p,lp]=shortest_path(i,j,g,typ)
[lhs,rhs]=argn(0)
if rhs=3 then
  typ='arc'
else
  if rhs<>4 then error(39), end
end
// check i and j
if prod(size(i))<>1 then
  error('shortest_path: first argument must be a scalar')
end
if prod(size(j))<>1 then
  error('shortest_path: second argument must be a scalar')
end
// check typ
  if type(typ)<>10|prod(size(typ))<>1 then
    error('shortest_path: fourth argument must be a string')
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
// value of length
if g('edge_length')==[] then
  len=zeros(1,ma)
else
  len=g('edge_length')
end
// compute shortest path according to typ
select typ
case 'arc' then
  [l,v]=pcchna(i,lp,ls,n)
  p=prevn2p(i,j,v,la,lp,ls,g('directed'))
  lp=l(j)
case 'length'
  lneg=find(len<0)
  if lneg<>[] then 
    [l,v]=ford(i,la,len,lp,ls,n)
  else   
    if ma<0.5*n*n then 
      [l,v]=johns(i,la,len,lp,ls,n)
    else 
      [l,v]=dijkst(i,la,len,lp,ls,n)
    end
  end
  p=prevn2p(i,j,v,la,lp,ls,g('directed'))
  lp=l(j)
else
  error('shortest_path: unknown type ""'+typ+'""')
end
