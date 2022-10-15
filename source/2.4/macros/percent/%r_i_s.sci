function f2=%r_i_s(i,j,f2,n)
// %r_i_s(i,j,r,m) 
//!
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs==3 then
  n=f2;f2=j
  [l,c]=size(n),
  d=ones(l,c);
  n(i)=f2('num'),d(i)=f2('den')
  f2('num')=n;f2('den')=d;
else
  [l,c]=size(n),
  d=ones(l,c);
  n(i,j)=f2('num'),d(i,j)=f2('den')
  f2('num')=n;f2('den')=d;
end

