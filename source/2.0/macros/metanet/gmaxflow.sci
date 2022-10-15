function [v,f]=gmaxflow(g)
[lhs,rhs]=argn(0), if rhs==0 then g=the_g, end
is=find(g_ntype(g)==2), it=find(g_ntype(g)==1)
if prod(size(is)) <> 1 then 
  error('there must be one and only one source') 
end
if prod(size(it)) <> 1 then 
  error('there must be one and only one sink') 
end
compat=find(g_mincap(g)>0|g_maxcap(g)<0)
if compat=[] then [v,f]=maxflow(is,it,g)
else ff=kilter(addra(g)),f=ff(1:g_edgnum(g)),v=ff(g_edgnum(g)+1), end
