function [stk,txt,top]=%i2sci()
//
//!
// Copyright INRIA
txt=[]
rhs=abs(evstr(op(3)))-2
sto=stk(top);top=top-1
sfrom=stk(top);top=top-1
top=top-rhs+1
s2=stk(top)
if rhs==1 then
  if s2(1)<>':' then
    if sto(3)=='0'|sto(4)=='0' then
      txt=sto(1)+'(1,'+s2(1)+') = '+sfrom(1)+';'
    else
      txt=sto(1)+'('+s2(1)+') = '+sfrom(1)+';'
    end
    stk=list(op(2),'-1','?','?',sto(5))
  else
    txt=sto(1)+' = matrix'+rhsargs([sfrom(1),'size('+sto(1)+',1)','size('+sto(1)+',2)'])+';'
    stk=list(op(2),'-1','?','1',sto(5))
  end
else
  s1=stk(top+1)
  txt=sto(1)+rhsargs([s2(1),s1(1)])+' = '+sfrom(1)+';'
  stk=list(op(2),'-1','?','?',sto(5))
end


 



