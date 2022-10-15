function sp=g_sin(a)
[ij,v,mn]=spget(a)
sp=sparse(ij,sin(v),mn)
