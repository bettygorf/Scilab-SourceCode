function g1=addra(g)
[lhs,rhs]=argn(0), if rhs==0 then g=the_g, end
is=find(g_ntype(g)==2), it=find(g_ntype(g)==1)
if prod(size(is)) <> 1 then 
  error('there must be one and only one source') 
end
if prod(size(it)) <> 1 then 
  error('there must be one and only one sink') 
end
if g_direct(g) == 0 then error('graph must be directed'), end
m=g_arcnum(g), n=g_nodnum(g),
p1=g_lp1(g), for i=it+1:n+1, p1(i)=p1(i)+1, end
a1=g_la1(g), na1=a1, na1(1,p1(it))=m+1 
for i=p1(it)+1:m+1, na1(1,i)=a1(i-1), end
s1=g_ls1(g), ns1=s1, ns1(1,p1(it))=is, 
for i=p1(it)+1:m+1, ns1(1,i)=s1(i-1), end
[a2,p2,s2]=compl2(na1,p1,ns1,1)
[he,ta]=compht(na1,p1,ns1,1)
mi=g_mincap(g), vmi=0, for i=1:m, vmi=vmi+mi(i), end
ma=g_maxcap(g), vma=0, for i=1:m, vma=vma+ma(i), end
g1=list(' ',1,m+1,n,m+1,2*(m+1),na1,p1,ns1,a2,p2,s2,he,ta,...
g_ntype(g),g_xnode(g),g_ynode(g),g_ncolor(g),g_demand(g),[g_acolor(g) 0],... 
[g_alen(g) 0],[0*(1:m) -1],[g_mincap(g) vmi],[g_maxcap(g) vma],...
[g_qweig(g) 0],[g_qorig(g) 0],[g_aweig(g) 0])
