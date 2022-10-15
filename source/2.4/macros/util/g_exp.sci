function sp=g_exp(a)
// Copyright INRIA
[ij,v,mn]=spget(a)
sp=sparse(ij,exp(v),mn)

