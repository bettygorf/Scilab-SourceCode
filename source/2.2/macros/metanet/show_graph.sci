function []=show_graph(g,rep,scale)
[lhs,rhs]=argn(0)
select rhs
case 1 then
  rep='pas de rep'
  scale=-1
case 2 then
  if type(rep)==10 then scale=-1
  else scale=rep, rep='pas de rep', end
else
  if rhs<>3 then error(39), end
end
// g
check_graph(g)
// making defaults
n=g('node_number')
ma=g('edge_number')
// node_name
if size(g('node_name'))==0 then
  g('node_name')=string(1:n)
end
// node_type
if size(g('node_type'))==0 then
  g('node_type')=0*(1:n)
end
// node_x
if size(g('node_x'))==0 then
  g('node_x')=0*(1:n)
end
// node_y
if size(g('node_y'))==0 then
  g('node_y')=0*(1:n)
end
// node_color
if size(g('node_color'))==0 then
  g('node_color')=0*(1:n)
end
// node_diam
if size(g('node_diam'))==0 then
  g('node_diam')=0*(1:n)
end
// node_border
if size(g('node_border'))==0 then
  g('node_border')=0*(1:n)
end
// node_font_size
if size(g('node_font_size'))==0 then
  g('node_font_size')=0*(1:n)
end
// node_demand
if size(g('node_demand'))==0 then
  g('node_demand')=0*(1:n)
end
// edge_name
if size(g('edge_name'))==0 then
  g('edge_name')=string(1:ma)
end
// edge_color
if size(g('edge_color'))==0 then
  g('edge_color')=0*(1:ma)
end
// edge_width
if size(g('edge_width'))==0 then
  g('edge_width')=0*(1:ma)
end
// edge_hi_width
if size(g('edge_hi_width'))==0 then
  g('edge_hi_width')=0*(1:ma)
end
// edge_font_size
if size(g('edge_font_size'))==0 then
  g('edge_font_size')=0*(1:ma)
end
// edge_length
if size(g('edge_length'))==0 then
  g('edge_length')=0*(1:ma)
end
// edge_cost
if size(g('edge_cost'))==0 then
  g('edge_cost')=0*(1:ma)
end
// edge_min_cap
if size(g('edge_min_cap'))==0 then
  g('edge_min_cap')=0*(1:ma)
end
// edge_max_cap
if size(g('edge_max_cap'))==0 then
  g('edge_max_cap')=0*(1:ma)
end
// edge_q_weight
if size(g('edge_q_weight'))==0 then
  g('edge_q_weight')=0*(1:ma)
end
// edge_q_orig
if size(g('edge_q_orig'))==0 then
  g('edge_q_orig')=0*(1:ma)
end
// edge_weight
if size(g('edge_weight'))==0 then
  g('edge_weight')=0*(1:ma)
end
// default_node_diam
if size(g('default_node_diam'))==0 then
  g('default_node_diam')=0
end
// default_node_border
if size(g('default_node_border'))==0 then
  g('default_node_border')=0
end
// default_edge_width
if size(g('default_edge_width'))==0 then
  g('default_edge_width')=0
end
// default_edge_hi_width
if size(g('default_edge_hi_width'))==0 then
  g('default_edge_hi_width')=0
end
// default_font_size
if size(g('default_font_size'))==0 then
  g('default_font_size')=0
end
// node_label
is_nlabel=1
if size(g('node_label'))==0 then
  g('node_label')=string(zeros(1,n))
  is_nlabel=0
end
// edge_label
is_elabel=1
if size(g('edge_label'))==0 then
  g('edge_label')=string(zeros(1,ma))
  is_elabel=0
end
// scale
if prod(size(scale))<>1 then
  error('show_graph: scale argument must be a scalar')
end
if scale<=0 then scale=-1, end
// rep
if type(rep)<>10|prod(size(rep))<>1 then
  error('show_graph: second argument must be a string')
end
select rep
case 'pas de rep' then
  irep=0
case 'rep' then 
  irep=1
case 'new' then
  // if rep is 'new' create a new window without question
  irep=0
  inimet(' ')
else
  error('show_graph: unknown argument ""'+rep+'""')  
end
// Is there a current metanet window?
r=netwindows(); cw=r(2)
if cw==0 then 
  cw=inimet(' ')
end
showg(g,g('name'),ma,cw,irep,scale,is_nlabel,is_elabel)
