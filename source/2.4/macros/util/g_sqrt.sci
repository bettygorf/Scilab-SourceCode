function sp=g_sqrt(a)
// Copyright INRIA
[ij,v,mn]=spget(a)
sp=sparse(ij,sqrt(v),mn)
