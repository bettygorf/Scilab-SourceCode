function f1=%r_x_s(f1,n2)
// %r_x_s(r,M)=r.*M      rational .* constant
//!
// Copyright INRIA
if size(n2,'*')==0
  f1=[]
else
  f1(2)=f1(2).*n2
end



