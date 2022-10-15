function g1=l2g(a1,p1,s1,dir)
[a2,p2,s2]=compl2(a1,p1,s1,dir)
[he,ta]=compht(a1,p1,s1,dir)
m=prod(size(s1)), n=prod(size(p1))-1
if dir==1 then ma=m, mm=2*m
else ma=m/2,mm=m, end
g1=list(' ',dir,m,n,ma,mm,a1,p1,s1,a2,p2,s2,he,ta,...
n,1:n,ma,1:ma,...
0*(1:n),0*(1:n),0*(1:n),0*(1:n),0*(1:n),0*(1:ma),... 
0*(1:ma),0*(1:ma),0*(1:ma),0*(1:ma),0*(1:ma),0*(1:ma),0*(1:ma))
