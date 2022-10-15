function [stk,txt,top]=sci_log2()
// Copyright INRIA
txt=[]
if lhs==1 then
  stk=list('log('+stk(top)(1)+')/log(2)','0',stk(top)(3),stk(top)(4),'1')
else
  f=lst(ilst+1)(2)
  e=lst(ilst+2)(2)
  txt=[e+' = ceil(log('+stk(top)(1)+')/log(2));';
      f+' = '+stk(top)(1)+'-(2^'+e+');']
  stk=list(list('?','-2',stk(top)(3),stk(top)(3),'?'),list('?','-2',stk(top)(3),stk(top)(3),'?'))
end




