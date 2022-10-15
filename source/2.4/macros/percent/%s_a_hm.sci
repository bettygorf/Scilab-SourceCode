function M2=%s_a_hm(M1,M2)
// Copyright INRIA
// scalar +hypermatrix
if or(size(M1)<>[1 1]) then
  error(8)
end
M2('entries')=M1+M2('entries')




