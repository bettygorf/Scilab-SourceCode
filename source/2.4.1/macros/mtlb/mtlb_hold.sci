function mtlb_hold(flag)
[lhs,rhs]=argn(0)
if rhs==0 then
  if exists('%MTLBHOLD')==0 then
    %MTLBHOLD=%t
  else
    %MTLBHOLD=~%MTLBHOLD
  end
elseif convstr(flag)=='on' then
  %MTLBHOLD=%t
else
  %MTLBHOLD=%f
end
%MTLBHOLD=resume(%MTLBHOLD)
