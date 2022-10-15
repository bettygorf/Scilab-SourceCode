function r=mtlb_ishold()
[lhs,rhs]=argn(0)
if exists('%MTLBHOLD')==0 then
  r=%f
else
  r=%MTLBHOLD
end

