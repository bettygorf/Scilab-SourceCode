function scs_m=do_tild(scs_m)
// Copyright INRIA
while %t
  [btn,xc,yc,win,Cmenu]=cosclick()
  if Cmenu<>[] then
    Cmenu=resume(Cmenu)
  end
  k=getblock(scs_m,[xc;yc])
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
scs_m_save=scs_m
scs_m(k)=o
[scs_m_save,enable_undo,edited]=resume(scs_m_save,%t,%t)


