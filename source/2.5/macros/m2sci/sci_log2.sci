function [stk,txt,top]=sci_log2()
// Copyright INRIA
txt=[]
if lhs==1 then
  stk=list('log('+stk(top)(1)+')/log(2)','0',stk(top)(3),stk(top)(4),'1')
else
  [f,e]=lhsvarsnames()
  k=gettempvar(0)
  if isname(stk(top)(1)) then
    v=stk(top)(1)
  else
    v=gettempvar(1)
    txt=v+' = '+stk(top)(1)
  end
  txt=[txt;k+' = find('+v+'<>0);'
      e+'('+k+') = ceil(log(abs('+v+'('+k+')))/log(2));';
      f+'('+k+') = '+v+'('+k+')./(2^'+e+'('+k+'));'
      k+' = find('+f+'>=1);'
      f+'('+k+') = 0.5'
      e+'('+k+') = '+e+'('+k+')+1']
  stk=list(list('?','-2',stk(top)(3),stk(top)(3),'?'),list('?','-2',stk(top)(3),stk(top)(3),'?'))
end




