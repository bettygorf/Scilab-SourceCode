function scs_m=do_color(scs_m)
// do_block - edit a block icon
// Copyright INRIA
while %t
  [btn,xc,yc,win,Cmenu]=getclick()
  if Cmenu<>[] then
    Cmenu=resume(Cmenu)
  end
  K=getobj(scs_m,[xc;yc])
  if K<>[] then break,end
end
o=scs_m(K)
if o(1)=='Link' then
  [nam,pos,ct]=o(5:7)
  c=getcolor('Choose a color',ct(1));
  if c<>[] then
    connected=connected_links(scs_m,K)
    for kc=connected
      o=scs_m(kc);ct=o(7)
      if ct(1)<>c then
	drawobj(o)
	o(7)(1)=c;
	drawobj(o)
	scs_m(kc)=o
      end
    end
  end
elseif o(1)=='Block' then
  graphics=o(2)
  gr_i=graphics(9)
  if type(gr_i)==10 then,gr_i=list(gr_i,[]),end
  if gr_i(2)==[] then
    coli=0
  else
    coli=gr_i(2)
  end
  coln=getcolor('color',coli)
  if coln<>[] then
    if coln<>coli then
      gr_i(2)=coln

      graphics(9)=gr_i
      drawblock(o)
      o(2)=graphics
      scs_m(K)=o
      drawblock(o)
    end
  end
elseif o(1)=='Text' then
  //not implemented
end
