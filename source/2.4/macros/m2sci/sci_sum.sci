function [stk,txt,top]=sci_sum()
// Copyright INRIA
txt=[]
if rhs==1 then
  if stk(top)(3)=='1'| stk(top)(4)=='1' then
    stk=list('sum('+stk(top)(1)+')','0','1','1',stk(top)(5))
  else 
    stk=list('mtlb_sum('+stk(top)(1)+')','0','1',stk(top)(4),stk(top)(5))
  end
else
  if stk(top)(1)=='1' then
    stk=list('sum('+stk(top-1)(1)+',1)','0','1',stk(top-1)(4),stk(top-1)(5))
  elseif stk(top)(1)=='2' then  
    stk=list('sum('+stk(top-1)(1)+',2)','0',stk(top-1)(3),'1',stk(top-1)(5))
  else  
    x=stk(top)(1)
    stk=list('sum('+stk(top-1)(1)+','+x+')','0','?','?',stk(top-1)(5))
  end
  top=top-1
end


