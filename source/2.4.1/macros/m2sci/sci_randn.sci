function [stk,txt,top]=sci_randn()
// Copyright INRIA
txt=[]
if rhs==0 then
  stk=list('rand(1,''n'')','0','1','1','1','?')
elseif rhs==1 then
  if stk(top)(3)=='1'&stk(top)(4)=='1' then
    stk=list('rand('+stk(top)(1)+','+stk(top)(1)+',''n'')','0',stk(top)(1),stk(top)(1),'1','?')
  elseif (stk(top)(3)=='1'&stk(top)(4)=='2')|(stk(top)(3)=='2'&stk(top)(4)=='1') then
    temp=gettempvar()
    txt=[txt;temp+'='+stk(top)(1)]
    stk=list('rand('+temp+'(1),'+temp+'(2),''n'')','0','?','?','1','?')
  else
    write(logfile,'Warning: Not enough information using mtlb_rand instead of rand')
    stk=list('mtlb_rand('+stk(top)(1)+')','0','?','?','1','?')
  end
else
  stk=list('rand('+stk(top-1)(1)+','+stk(top)(1)+',''n'')','0',stk(top-1)(1),stk(top)(1),'1','?')
end


