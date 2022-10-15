function drawobjs(x)
nx=size(x)
for i=2:nx
  drawobj(x(i))
end
drawtitle(x(1))


