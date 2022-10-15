function scs_m=do_tild(scs_m)
while %t
  [btn,xc,yc]=xclick(0);
  pt=[xc,yc]
  [n,pt]=getmenu(datam,pt);
  if n>0 then n=resume(n),end
  k=getobj(scs_m,[xc;yc])
  if k<>[] then break,end
end
if get_connected(scs_m,k)<>[] then
  message('Connected block can''t be tilded')
  return
end
o=scs_m(k)
drawobj(o)
if pixmap then xset('wshow'),end
geom=o(2);geom(3)=~geom(3);o(2)=geom;
drawobj(o)
scs_m(k)=o


