function r=mtlb_median(a)
// Copyright INRIA
if size(a,1)==1|size(a,2)==1 then
  r=median(a)
else
  r=median(a,'r')
end
