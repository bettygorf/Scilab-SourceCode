function d=%r_triu(a,k)
// g_triu - implement triu function for sparse matrix, rationnal matrix ,..
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs==1 then k=0,end
d=syslin(a(4),triu(a(2),k),triu(a(3),k)+tril(ones(a(3)),k-1))
