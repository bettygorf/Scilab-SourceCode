function f=%sigra(i,val,f)
[lhs,rhs]=argn(0)
if rhs<>3 then error(39), end
if type(i)<>10 then error('The name of the element of the graph-list must be a string'), end
l=prod(size(i))
if l<>1 then error('The name of the element of the graph-list must be a string'), end
select i
case 'directed' then
  if prod(size(val))<>1 then
    error('""'+i+'""'+' must be a scalar')
  end
  f(3)=val
case 'node_number' then
  if prod(size(val))<>1 then
    error('""'+i+'""'+' must be a scalar')
  end
  f(4)=val   
case 'tail' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(5)=val
case 'head' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(6)=val
case 'node_type' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(8)=val
case 'node_x' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(9)=val
case 'node_y' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(10)=val
case 'node_color' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(11)=val
case 'node_diam' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(12)=val
case 'node_border' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(13)=val
case 'node_font_size' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(14)=val
case 'node_demand' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(15)=val
case 'edge_color' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(17)=val
case 'edge_width' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(18)=val
case 'edge_hi_width' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(19)=val
case 'edge_font_size' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(20)=val
case 'edge_length' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(21)=val
case 'edge_cost' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(22)=val
case 'edge_min_cap' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(23)=val
case 'edge_max_cap' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(24)=val
case 'edge_q_weight' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(25)=val
case 'edge_q_orig' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(26)=val
case 'edge_weight' then
  s=size(val)
  if s(1)<>1 then
    error('""'+i+'""'+' must be a row vector')
  end  
  f(27)=val
case 'default_node_diam' then
  if prod(size(val))<>1 then
    error('""'+i+'""'+' must be a scalar')
  end
  f(28)=val
case 'default_node_border' then
  if prod(size(val))<>1 then
    error('""'+i+'""'+' must be a scalar')
  end
  f(29)=val
case 'default_edge_width' then
  if prod(size(val))<>1 then
    error('""'+i+'""'+' must be a scalar')
  end
  f(30)=val
case 'default_edge_hi_width' then
  if prod(size(val))<>1 then
    error('""'+i+'""'+' must be a scalar')
  end
  f(31)=val
case 'default_font_size' then
  if prod(size(val))<>1 then
    error('""'+i+'""'+' must be a scalar')
  end
  f(32)=val
else
  error('Bad name of graph-list element: ""'+i+'""')
end
