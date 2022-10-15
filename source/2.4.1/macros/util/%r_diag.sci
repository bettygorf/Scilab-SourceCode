function d=%r_diag(a,k)
// %r_diag - implement diag function for  rational matrix ,..
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs==1 then k=0,end
[m,n]=size(a(2))
if m<>1&n<>1 then
  d=syslin(a(4),diag(a(2),k),diag(a(3),k))
else
  mn=max(m,n)
  den=ones(mn,mn)
  den=den-diag(diag(den,k))+diag(a(3),k)
  d=syslin(a(4),diag(a(2),k),den)
end
