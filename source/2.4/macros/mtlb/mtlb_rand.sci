function r=mtlb_rand(a)
// Copyright INRIA
if size(a)==[1 1] then
  r=rand(a,a)
else
  r=rand(a(1),a(2))
end
