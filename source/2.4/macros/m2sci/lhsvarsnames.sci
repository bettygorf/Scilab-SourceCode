function [x1,x2,x3,x4,x5,x6,x7,x8,x9,x10]=lhsvarsnames()
// Copyright INRIA
for k=1:lhs
  execstr('x'+string(k)+' = lst(ilst+'+string(k)+')(2)')
end
