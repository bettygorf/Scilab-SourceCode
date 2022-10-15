function [r,k]=mtlb_min(a)
// Copyright INRIA
// Copyright INRIA
if ~isreal(a,0) then 
  if size(a,1)==1|size(a,2)==1 then
    [r,k]=min(abs(a))
    r=a(k)
  else
    [r,k]=min(abs(a),'r')
    r=a(k,:)
  end
else
  a=real(a)
  if size(a,1)==1|size(a,2)==1 then
    [r,k]=min(a)
  else
    [r,k]=min(a,'r')
  end
end



