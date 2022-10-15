function [r,k]=mtlb_max(a)
// Copyright INRIA
if size(a,1)==1|size(a,2)==1 then
  [r,k]=max(a)
else
  [r,k]=max(a,'r')
end
