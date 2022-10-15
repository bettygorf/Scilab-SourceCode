function d=%r_tril(a,k)
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs==1 then k=0,end
d=syslin(a(4),tril(a(2),k),tril(a(3),k)+triu(ones(a(3)),k+1))
