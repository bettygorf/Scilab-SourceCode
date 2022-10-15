function sp=g_round(a)
[ij,v,mn]=spget(a)
sp=sparse(ij,round(v),mn)
