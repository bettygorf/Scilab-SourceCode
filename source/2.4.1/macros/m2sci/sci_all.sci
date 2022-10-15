function [stk,txt,top]=sci_all()
// Copyright INRIA
// Copyright INRIA
txt=[]
v=stk(top-rhs+1)(1),
if rhs==1 then
  if stk(top)(3)=='1'| stk(top)(4)=='1' then
    stk=list('and('+v+')','0','1','1','4')
  else 
    stk=list('mtlb_all('+v+')','0','1',stk(top)(4),'4')
  end
else
  if stk(top)(1)=='1' then
    stk=list('and('+v+',1)','0','1',stk(top-1)(4),'4')
  elseif stk(top)(1)=='2' then  
    stk=list('and('+v+',2)','0',stk(top-1)(3),'1','4')
  else  
    x=stk(top)(1)
    stk=list('and('+v+','+x+')','0','?','?','4')
  end
  top=top-1
end

  
