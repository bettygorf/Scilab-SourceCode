function z=zeros(n,m)
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs==1 then
z=0*ones(n);return;end
if rhs==2 then
z=0*ones(n,m);return;end
