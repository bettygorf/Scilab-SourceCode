function scr=metanet(path)
[lhs,rhs]=argn(0) 
if rhs==0 then 
  path=" "
else
  if rhs<>1 then error(39),end
end
// path
if type(path)<>10|prod(size(path))<>1 then
  error('metanet: the argument must be a string')
end
scr=inimet(path)
