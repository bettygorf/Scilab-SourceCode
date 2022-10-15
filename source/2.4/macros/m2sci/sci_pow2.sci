function [stk,txt,top]=sci_pow2()
// Copyright INRIA
txt=[]
if lhs==1 then
  if stk(top)(2)=='2' then stk(top)(2)='('+stk(top)(2)+')',end
  stk=list('2.^'+stk(top)(1),'2',stk(top)(3),stk(top)(4),'1')
else
  f=stk(top)(2);e=stk(top-1)(2);
  if f=='2' then f='('+f+')',end
  if e=='2' then e='('+e+')',end
  stk=list(f+'.*+2 .^'+e)
end
