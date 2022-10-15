function [e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,..
	e11,e12,e13,e14,e15,e16,e17,e18,e19,e20,..
	e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,..
	e31]=%grae(i,f)
[lhs,rhs]=argn(0)
if rhs<>2 then error(39), end
if type(i)<>10 then error('The name of the element of the graph-list must be a string'), end
l=prod(size(i))
if lhs<>l then error(41), end
n=f(4)
ma=prod(size(f(5)))
direct=f(3)
for k=1:l
  select i(k)
  case 'name' then
    execstr('e'+string(k)+'=f(2)')
  case 'directed' then
    execstr('e'+string(k)+'=f(3)')
  case 'node_number' then
    execstr('e'+string(k)+'=f(4)')    
  case 'tail' then
    execstr('e'+string(k)+'=f(5)')
  case 'head' then
    execstr('e'+string(k)+'=f(6)')
  case 'node_name' then
    execstr('e'+string(k)+'=f(7)')
  case 'node_type' then
    execstr('e'+string(k)+'=f(8)')
  case 'node_x' then
    execstr('e'+string(k)+'=f(9)')
  case 'node_y' then
    execstr('e'+string(k)+'=f(10)')
  case 'node_color' then
    execstr('e'+string(k)+'=f(11)')
  case 'node_diam' then
    execstr('e'+string(k)+'=f(12)')
  case 'node_border' then
    execstr('e'+string(k)+'=f(13)')
  case 'node_font_size' then
    execstr('e'+string(k)+'=f(14)')
  case 'node_demand' then
    execstr('e'+string(k)+'=f(15)')
  case 'edge_name' then
    execstr('e'+string(k)+'=f(16)')
  case 'edge_color' then
    execstr('e'+string(k)+'=f(17)')
  case 'edge_width' then
    execstr('e'+string(k)+'=f(18)')
  case 'edge_hi_width' then
    execstr('e'+string(k)+'=f(19)')
  case 'edge_font_size' then
    execstr('e'+string(k)+'=f(20)')
  case 'edge_length' then
    execstr('e'+string(k)+'=f(21)')
  case 'edge_cost' then
    execstr('e'+string(k)+'=f(22)')
  case 'edge_min_cap' then
    execstr('e'+string(k)+'=f(23)')
  case 'edge_max_cap' then
    execstr('e'+string(k)+'=f(24)')
  case 'edge_q_weight' then
    execstr('e'+string(k)+'=f(25)')
  case 'edge_q_orig' then
    execstr('e'+string(k)+'=f(26)')
  case 'edge_weight' then
    execstr('e'+string(k)+'=f(27)')
  case 'default_node_diam' then
    execstr('e'+string(k)+'=f(28)')
  case 'default_node_border' then
    execstr('e'+string(k)+'=f(29)')
  case 'default_edge_width' then
    execstr('e'+string(k)+'=f(30)')
  case 'default_edge_hi_width' then
    execstr('e'+string(k)+'=f(31)')
  case 'default_font_size' then
    execstr('e'+string(k)+'=f(32)')
  case 'node_label' then
    execstr('e'+string(k)+'=f(33)')
  case 'edge_label' then
    execstr('e'+string(k)+'=f(34)')
  case 'edge_number' then
    execstr('e'+string(k)+'=ma')     
  case 'arc_number' then
    if f(3)==1 then m=ma, else m=2*ma, end
    execstr('e'+string(k)+'=m')
  else
    error('Bad name of graph-list element: '+string(i(k)))
  end 
end
