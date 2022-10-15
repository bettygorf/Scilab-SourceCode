function [stk,txt,top]=sci_zeros()
// Copyright INRIA
txt=[]
if rhs==0 then
  stk=list('0','0','1','1','1','?')
  top=top+1
elseif rhs==1 then
  if stk(top)(3)=='1'&stk(top)(4)=='1' then
    stk=list('zeros('+stk(top)(1)+','+stk(top)(1)+')','0',stk(top)(1),stk(top)(1),'1','?')
  elseif (stk(top)(3)=='1'&stk(top)(4)=='2')|(stk(top)(3)=='2'&stk(top)(4)=='1') then
    temp=gettempvar()
    txt=temp+'='+stk(top)(1)
    stk=list('zeros('+temp+'(1),'+temp+'(2))','0','?','?','1','?')
  else
    write(logfile,'Warning: Not enough information using mtlb_zeros instead of zeros')
    stk=list('mtlb_zeros('+stk(top)(1)+')','0','?','?','1','?')
  end
else
  stk=list('zeros('+stk(top-1)(1)+','+stk(top)(1)+')','0',stk(top-1)(1),stk(top)(1),'1','?')
  top=top-1
end


