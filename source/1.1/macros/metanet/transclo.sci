function g1=transclo(g)
[lhs,rhs]=argn(0), if rhs==0 then g=the_g, end
[lp,ls]=transc(g)
m=prod(size(ls)), la=1:m
if g_direct(g)==1 then ma=m, mm=2*m
else ma=m/2,mm=m, end
n=g_nodnum(g)
[a2,p2,s2]=compl2(la,lp,ls,g_direct(g))
[he,ta]=compht(la,lp,ls,g_direct(g))
g1=list(' ',g_direct(g),m,n,ma,mm,la,lp,ls,a2,p2,s2,he,ta,...
g_ntype(g),g_xnode(g),g_ynode(g),g_ncolor(g),g_demand(g),0*(1:m),... 
0*(1:m),0*(1:m),0*(1:m),0*(1:m),0*(1:m),0*(1:m),0*(1:m))
