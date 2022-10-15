function [m,n,nx]=%lss_size(x,flag)
// only to be called by size function for dynamical systems 
//!
// Copyright INRIA
[lhs,rhs]=argn(0)

[a,b,c,d]=x(2:5);[m,w]=size([c,d]),[w,n]=size([b;d]);
if lhs==1
  if rhs==1 then
    m=[m,n]
  elseif flag==1|part(flag,1)=='r' then
    m=m
  elseif flag==2|part(flag,1)=='2' then 
    m=n
  elseif flag=='*' then   
    m=m*n
  end
elseif lhs==2 then 
  
elseif lhs==3 then 
  [nx,nx]=size(a);
end;
