function t=atanhm(x)
//Matrix wise Hyperbolic tangent inverse 

if type(x)<>1 then error(53),end
if x==[] then t=[],end
[m,n]=size(x)
if m<>n then 
  error(20)
else 
  t=logm((eye+x)*sqrtm(eye/(eye-x*x)))
end

