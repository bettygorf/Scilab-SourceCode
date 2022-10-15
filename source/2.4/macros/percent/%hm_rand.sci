function M=%hm_rand(M)
// Copyright INRIA
//creates a random hypermatrix with shape given by vector of dimensions or an
//hypermatrix
if type(M)==1 then
  dims=M
else
  dims=M('dims')
end
M=mlist(['hm','dims','entries'],dims,rand(prod(dims),1))




