function [sp]=spzeros(m,n)
[lhs,rhs]=argn(0)
if rhs==1 then [m,n]=size(m),end
mn=mini(m,n)
sp=sparse([],[],[m,n])


