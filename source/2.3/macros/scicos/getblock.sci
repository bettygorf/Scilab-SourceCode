function k=getblock(objs,pt)
n=size(objs)
x=pt(1);y=pt(2)
data=[]
for i=2:n
  k=i
  o=objs(i)
  if o(1)=='Block'|o(1)=='Text' then
    [orig,sz]=o(2)(1:2);dx=sz(1)/7;dy=sz(2)/7
    data=[(orig(1)-dx-x)*(orig(1)+sz(1)+dx-x),..
	  (orig(2)-dy-y)*(orig(2)+sz(2)+dy-y)]
    if data(1)<0&data(2)<0 then return,end
  end
end
k=[]


