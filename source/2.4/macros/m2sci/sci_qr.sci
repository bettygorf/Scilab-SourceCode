function [stk,txt,top]=sci_qr()
// Copyright INRIA
txt=[]
s=stk(top)
if lhs==1 then
  write(logfile,'Warning: No scilab eqivalent to qr with only one lhs arg using mtlb_qr')
  stk=list('mtlb_qr('+s(1)+')','0',s(3),s(4),'1','?')
elseif lhs==2 then
  stk=list(list('qr('+s(1)+')','-1',s(3),s(4),'1','?'),..
           list('qr('+s(1)+')','-1',s(3),s(4),'1','?'))
else
  r= list('qr('+s(1)+')','-1',s(3),s(4),'1','?')
  stk=list(r,r,r)     
end

