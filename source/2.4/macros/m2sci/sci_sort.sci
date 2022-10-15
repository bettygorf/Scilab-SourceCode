function [stk,txt,top]=sci_sort()
// Copyright INRIA
txt=[]
temp=gettempvar()
if lhs==1 then  
  if stk(top)(3)=='1'|stk(top)(4)=='1' then
    txt=temp+' = sort('+stk(top)(1)+')'
    stk=list(temp+'($:-1:1)','0',stk(top)(3),stk(top)(4),'1')
  else
    txt=[temp+' = '+stk(top)(1)
        'if min(size('+temp+'))==1 then '+temp+'=sort('+temp+'),else '+temp+'=sort('+temp+',''r''),end']
    stk=list(temp+'($:-1:1,:)','0',stk(top)(3),stk(top)(4),'1')
  end
else
  y=lst(ilst+1)(2)
  i=lst(ilst+2)(2)
  if stk(top)(3)=='1'|stk(top)(4)=='1' then
    txt=['['+y+','+i+'] = sort('+stk(top)(1)+')'
        y+' = '+y+'($:-1:1)'
        i+' = '+i+'($:-1:1)']
  else
    txt=[temp+' = '+stk(top)(1)
        'if min(size('+temp+'))==1 then '
        '  ['+y+','+i+']=sort('+temp+')'
        'else '
        '  ['+y+','+i+']=sort('+temp+',''r'')'
        'end'
        y+' = '+y+'($:-1:1)'
        i+' = '+i+'($:-1:1)']
  end
  stk=list(list('?','-2',stk(top)(3),stk(top)(4),'1'),..
      list('?','-2',stk(top)(3),stk(top)(4),'1'))
end
