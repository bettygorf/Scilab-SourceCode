function [scs_m,modified]=do_delete_region(scs_m,xc,yc)
xinfo('Drag to select region and click to fix the selection')
rep(3)=-1
ox=xc
oy=yc
w=0;h=0
while rep(3)==-1 do
  xrect(ox,oy,w,h)
  rep=xgetmouse(0);
  xrect(ox,oy,w,h)
  xc1=rep(1);yc1=rep(2)
  ox=mini(xc,xc1)
  oy=maxi(yc,yc1)
  w=abs(xc-xc1);h=abs(yc-yc1)
end
xrect(ox,oy,w,h)
del=[]
for k=2:size(scs_m)
  o=scs_m(k)
  if o(1)=='Block'|o(1)=='Text' then
    // check if block is outside rectangle
    orig=o(2)(1)
    sz=o(2)(2)
    x=[0 1 1 0]*sz(1)+orig(1)
    y=[0 0 1 1]*sz(2)+orig(2)
    ok=%f
    for kk=1:4
      data=[(ox-x(kk))'*(ox+w-x(kk)),(oy-h-y(kk))'*(oy-y(kk))];
      if data(1)<0&data(2)<0 then ok=%t;del=[del k];break;end
    end
  end
end
modified=del<>[]
[scs_m,DEL,DELL]=do_delete1(scs_m,del,%t)
xrect(ox,oy,w,h)
