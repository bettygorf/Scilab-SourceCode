function t=mintree(i,g)
[lhs,rhs]=argn(0),
if rhs==0 then i=1, g=the_g
elseif rhs==1 then
  if type(i)==15 then g=i, i=1
  else g=the_g, end
end
if (i<0 | i>g_nodnum(g)) then 
  error('bad internal node number') 
end
if g_direct(g)==1 then
  alf=dmtree(i,g), t=prevn2st(alf,g)
else if g_edgnum(g)<0.5*g_nodnum(g)*g_nodnum(g) then alf=umtree1(g)
     else alf=umtree(g),end
     t=edge2st(alf,g) 
end
