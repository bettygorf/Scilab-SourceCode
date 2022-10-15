function scs_m=do_color(scs_m)
// do_block - edit a block icon
while %t
  [btn,xc,yc]=xclick(0);
  pt=[xc,yc]
  [n,pt]=getmenu(datam,pt);
  if n>0 then n=resume(n),end
  K=getblock(scs_m,[xc;yc])
  if K<>[] then break,end
end
o=scs_m(K)
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
