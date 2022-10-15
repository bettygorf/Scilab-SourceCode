function win=systshow(x,win)
[lhs,rhs]=argn(0)
if rhs<2 then win=xget('window'),end
xset('window',win);xbasc()
wpar=x(1)
wsiz=wpar(1)
xset('wdim',wsiz(1),wsiz(2))
[frect1,frect]=xgetech()
wdm=xget('wdim')
xsetech([-1 -1 8 8]/6,[0 0 wdm(1) wdm(2)])
drawobjs(x)
nx=size(x)
for k=2:nx
  o=x(k)
  if o(1)=='Block' then
    model=o(3)
    if model(1)=='super' then
      win=win+1
      win=systshow(model(8),win)
    end
  end      
end
