function [r,k]=mtlb_min(a)
// Copyright INRIA
if size(a,1)==1|size(a,2)==1 then
  [r,k]=min(a)
else
  [r,k]=min(a,'r')
end


