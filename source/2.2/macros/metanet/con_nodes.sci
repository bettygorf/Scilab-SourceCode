function ns=con_nodes(i,g)
[lhs,rhs]=argn(0)
if rhs<>2 then error(39), end
// check i
if prod(size(i))<>1 then
  error('con_nodes: first argument must be a scalar')
end
// checking of g is made in connex
[l,nc]=connex(g)
ns=concom(i,nc)
