function f2=%s_x_r(n1,f2)
// %s_x_r(M,r) = (M.*r)   constant .* rational
//!
// Copyright INRIA
if size(n1,'*')==0 then 
  f2=[]
else
  f2(2)=n1.*f2(2)
end


