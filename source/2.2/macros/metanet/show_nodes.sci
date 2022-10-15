function show_nodes(ns,sup)
[lhs,rhs]=argn(0)
if rhs==1 then
  sup='pas de sup'
else
  if rhs<>2 then error(39), end 
end
// ns
s=size(ns)
if s(1)*s(2) == 0 then return end
if s(1)<>1 then
  error('show_nodes: first argument must be a row vector')
end
// sup
if type(sup)<>10|prod(size(sup))<>1 then
  error('show_nodes: second argument must be a string')
end
select sup
case 'pas de sup' then
  isup=0
case 'sup' then 
  isup=1
else
  error('show_nodes: unknown argument ""'+sup+'""')  
end
showns(ns,isup)
