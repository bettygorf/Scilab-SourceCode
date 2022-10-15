function sp=g_exp(a)
[ij,v,mn]=spget(a)
sp=sparse(ij,exp(v),mn)

