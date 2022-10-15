function [f1,f2,f3,f4,f5]=%r_e(i,j,f)
// %r_e(i,j,f) extraction f(i,j) in a rational matrix
//!
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs==2 then
  f1=j
  f1('num')=f1('num')(i)
  f1('den')=f1('den')(i)
  if f1('num')==[] then f1=[],end
else
  f1=f;
  [n,d]=f1(['num','den'])
  f1('num')=n(i,j);f1('den')=d(i,j)
  if f1('num')==[] then f1=[],end
end
