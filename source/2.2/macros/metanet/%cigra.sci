function f=%cigra(i,val,f)
[lhs,rhs]=argn(0)
if rhs<>3 then error(39),end
if type(i)<>10 then error('The name of the element of the graph-list must be a string'), end
l=prod(size(i))
if l<>1 then error('The name of the element of the graph-list must be a string'), end;
select i
case 'name' then
  if type(val)<>10|prod(size(val))<>1 then
    error('""'+i+'""'+' must be a string')
  end
  f(2)=val
case 'node_name' then
  s=size(val)
  if type(val)<>10|s(1)<>1 then
    error('""'+i+'""'+' must be a row vector of strings')
  end
  f(7)=val
case 'edge_name' then
  s=size(val)
  if type(val)<>10|s(1)<>1 then 
    error('""'+'""'+i+' must be a row vector of strings')
  end
  f(16)=val 
case 'node_label' then
  s=size(val)
  if type(val)<>10|s(1)<>1 then
    error('""'+i+'""'+' must be a row vector of strings')
  end
  f(33)=val
case 'edge_label' then
  s=size(val)
  if type(val)<>10|s(1)<>1 then 
    error('""'+'""'+i+' must be a row vector of strings')
  end
  f(34)=val 
else
  error('Bad name of graph-list element: ""'+i+'""')
end
