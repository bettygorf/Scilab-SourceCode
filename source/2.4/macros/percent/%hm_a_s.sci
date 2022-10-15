function M1=%hm_a_s(M1,M2)
// Copyright INRIA
// hypermatrix + scalar
if or(size(M2)<>[1 1]) then
  error(8)
end
M1('entries')=M1('entries')+M2




