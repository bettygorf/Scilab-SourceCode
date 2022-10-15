function scs_m=do_resize(scs_m)
// Copyright INRIA
while %t
  [btn,xc,yc,win,Cmenu]=getclick()
  if Cmenu<>[] then
    Cmenu=resume(Cmenu)
  end
  K=getblock(scs_m,[xc;yc])
  if K<>[] then break,end
end
o=scs_m(K)

graphics=o(2)
sz=graphics(2)
orig=graphics(1)
[ok,w,h]=getvalue('Set Block sizes',['width';'height'],..
    list('vec',1,'vec',1),string(sz(:)))
if ok  then
  w=maxi(w,20)
  h=maxi(h,20)

  if w<>sz(1) then
    if [get_connected(scs_m,K,'out'),..
	get_connected(scs_m,K,'clkin'),..
	get_connected(scs_m,K,'clkout')]<>[] then 
      message(['Block with connected standard port outputs'
	  'or Event ports cannot be resized horizontally'])
      return
    end
  end
  if h<>sz(2) then
    if [get_connected(scs_m,K,'out'),..
	get_connected(scs_m,K,'in'),..
	get_connected(scs_m,K,'clkin')]<>[] then 
      message(['Block with connected standards ports'
	  'or Event input ports cannot be resized vertically'])
      return
    end
  end
  graphics(2)=[w;h]
  graphics(1)=orig
  drawblock(o)
  o(2)=graphics
  scs_m(K)=o
  drawblock(o)
end


