function [c,f,v]=minicf(iv,g)
[lhs,rhs]=argn(0), if rhs==1 then g=the_g, end
is=find(g_ntype(g)==2), it=find(g_ntype(g)==1)
if prod(size(is)) <> 1 then 
  error('there must be one and only one source') 
end
if prod(size(it)) <> 1 then 
  error('there must be one and only one sink') 
end
verif=find(g_mincap(g)<>0)
if verif<>[] then error('minimum capacities must be equal to zero'), end
verif=find(g_maxcap(g)<0) 
if verif<>[] then error('maximum capacities must be non negative'), end
verif=find(g_acost(g)<0) 
if verif<>[] then error('costs must be non negative'), end
[v,f]=busack(is,it,iv,g)
c=g_acost(g)*f'
