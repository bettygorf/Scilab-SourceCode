function sp=g_sqrt(a)
[ij,v,mn]=spget(a)
sp=sparse(ij,sqrt(v),mn)
