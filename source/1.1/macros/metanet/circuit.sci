function p=circuit(g)
[lhs,rhs]=argn(0), if rhs==0 then g=the_g, end
[i,r]=frank(g)
if i==0 then p=[]
else p=prevn2p(i,i,r,g)
end
