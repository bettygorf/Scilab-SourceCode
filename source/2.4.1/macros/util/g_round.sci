function sp=g_round(a)
// Copyright INRIA
[ij,v,mn]=spget(a)
sp=sparse(ij,round(v),mn)
