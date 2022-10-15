function [m,n,nx]=g_size(x,flag)
// only to be called by size function for dynamical systems 
//!
[lhs,rhs]=argn(0)
x1=x(1);
if x1(1)=='r' then
  if lhs==1 then 
    if rhs==1 then
      m=size(x(2));
    else
      m=size(x(2),flag);
    end
  elseif lhs==2 then 
    if rhs<>1 then error(41),end
    [m,n]=size(x(2));
  elseif lhs>2 then 
    error('bad call to size function (not state-space!)');
  end
else
  [a,b,c,d]=x(2:5);[m,w]=size([c,d]),[w,n]=size([b;d]);
  if lhs==1 then 
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
end
