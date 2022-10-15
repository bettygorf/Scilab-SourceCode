function [stk,txt,top]=sci_max()
// Copyright INRIA
txt=[]
v=stk(top+1-rhs)(1)
if stk(top+1-rhs)(5)=='4' then 
  v='bool2s('+v+')'
end
if rhs==1 then
  if stk(top)(3)=='1'|stk(top)(4)=='1' then
    r=list('max('+v+')','0','1','1','1')
  else
    r=list('mtlb_max('+v+')','0','?','?','1')
  end
else
  r=list('max('+v+','+stk(top)(1)+')','0','?','?','1')
end

if lhs==1 then
  stk=r
else
  r(2)='-1'
  stk=list(r,r)
end

