function [k,wh]=getobj(objs,pt)
// Copyright INRIA
n=size(objs)
wh=[];
x=pt(1);y=pt(2)
data=[]
k=[]
for i=2:n //loop on objects
  o=objs(i)
  if o(1)=='Block' then
    graphics=o(2)
    [orig,sz]=graphics(1:2)
    data=[(orig(1)-x)*(orig(1)+sz(1)-x),(orig(2)-y)*(orig(2)+sz(2)-y)]
    if data(1)<0&data(2)<0 then k=i,break,end
  elseif o(1)=='Link' then
    [frect1,frect]=xgetech();
    eps=0.01*min(abs(frect(3)-frect(1)),abs(frect(4)-frect(2)))
    xx=o(2);yy=o(3);
    [d,ptp,ind]=dist2polyline(xx,yy,pt)
    if d<eps then k=i,wh=ind,break,end
  elseif o(1)=='Text' then
    graphics=o(2)
    [orig,sz]=graphics(1:2)
    data=[(orig(1)-x)*(orig(1)+sz(1)-x),(orig(2)-y)*(orig(2)+sz(2)-y)]
    if data(1)<0&data(2)<0 then k=i,break,end
  end
end




