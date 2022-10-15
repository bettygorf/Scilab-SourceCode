function t=acoshm(x)
//Matrix wise Hyberbolic cosine inverse of x
if type(x)<>1 then error(53),end
[m,n]=size(x)
if m<>n then 
  error(20)
else 
  t=logm(x+(x+eye)*sqrtm((x-eye)/(x+eye)))
end



