function [stk,txt,top]=sci_mean()
// Copyright INRIA
txt=[]

if stk(top)(3)=='1'|stk(top)(4)=='1' then
  x=stk(top)(1)
  if isname(x) then
    x=stk(top)(1)
  else
    x=gettempvar()
    txt=x+' = '+stk(top)(1)
  end
  e='sum('+x+')/size(x,''*'')'
  stk=list(e,'0','1','1','1')
else
  stk=list('mtlb_mean('+stk(top)(1)+')','0','1','?','1')
end



