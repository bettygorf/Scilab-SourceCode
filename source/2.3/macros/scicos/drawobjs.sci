function drawobjs(scs_m)
nx=size(scs_m)
for i=2:nx
  drawobj(scs_m(i))
end
drawtitle(scs_m(1))






