function x=do_tild(x)
while %t
  [n,pt]=getmenu(datam);xc=pt(1);yc=pt(2)
  if n>0 then n=resume(n),end
  //[btn,xc,yc]=xclick()
  k=getobj(x,[xc;yc])
  if k<>[] then break,end
end
if get_connected(x,k)<>[] then
  x_message('Connected block can''t be tilded')
  return
end
o=x(k)
drawobj(o)
if pixmap then xset('wshow'),end
geom=o(2);geom(3)=~geom(3);o(2)=geom;
drawobj(o)
x(k)=o
