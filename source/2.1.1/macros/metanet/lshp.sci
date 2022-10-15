function [p,lp]=lshp(i,j,g)
[lhs,rhs]=argn(0), if rhs==2 then g=the_g, end
if ( i<0 | i>g_nodnum(g) | j<0 | j>g_nodnum(g)) then 
  error('bad internal node number') 
end
lneg=find(g_alen(g)<0)
if lneg<>[] then 
  [l,v]=ford(i,g)
else   
  if g_edgnum(g)<0.5*g_nodnum(g)*g_nodnum(g) then [l,v]=johns(i,g)
  else [l,v]=dijkst(i,g), end
end
p=prevn2p(i,j,v,g),
lp=l(j)
