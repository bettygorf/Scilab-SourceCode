function [stk,txt,top]=sci_pow2()
// Copyright INRIA
txt=[]
if lhs==1 then
  if stk(top)(2)=='2'|stk(top)(2)=='3'|part(stk(top)(1),1)=='-' then stk(top)(1)='('+stk(top)(1)+')',end
  stk=list('2.^'+stk(top)(1),'2',stk(top)(3),stk(top)(4),'1')
else
  f=stk(top)(2);e=stk(top-1)(2);
  if f=='2'|f=='3' then stk(top)(1)='('+stk(top)(1)+')',end
  if e=='2'|e=='3'|part(stk(top-1)(1),1)=='-' then 
    stk(top-1)(1)='('+stk(top-1)(1)+')',
  end
  stk=list(stk(top)(1)+'.*+2 .^'+stk(top-1)(1))
end
