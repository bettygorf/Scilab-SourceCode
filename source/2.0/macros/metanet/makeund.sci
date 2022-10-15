function g1=makeund(g)
[lhs,rhs]=argn(0), if rhs==0 then g=the_g, end
if g_direct(g) == 0 then error('graph already undirected'), end
m=2*g_arcnum(g), ma=g_arcnum(g), mm=m
[a1,p1,s1]=compunl1(g_la1(g),g_lp1(g),g_ls1(g))
[a2,p2,s2]=compl2(a1,p1,s1,0)
[he,ta]=compht(a1,p1,s1,0)
g1=list(' ',0,m,g_nodnum(g),ma,mm,a1,p1,s1,a2,p2,s2,he,ta,...
g_ntype(g),g_xnode(g),g_ynode(g),g_ncolor(g),g_demand(g),g_acolor(g),... 
alenght(g),g_acost(g),g_mincap(g),g_maxcap(g),g_qweig(g),g_qorig(g),g_aweig(g))
