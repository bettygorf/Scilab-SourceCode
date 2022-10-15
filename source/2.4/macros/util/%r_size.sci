function [m,n,nx]=%r_size(x,flag)
// only to be called by size function for dynamical systems 
//!
// Copyright INRIA
[lhs,rhs]=argn(0)
x1=x(1);
if lhs==1 then 
  if rhs==1 then
    m=size(x(2));
  else
    m=size(x(2),flag);
  end
elseif lhs==2 then 
  if rhs<>1 then error(41),end
  [m,n]=size(x(2));
end
