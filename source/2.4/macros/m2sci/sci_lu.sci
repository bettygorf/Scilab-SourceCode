function [stk,txt,top]=sci_lu()
// Copyright INRIA
txt=[]
s=stk(top)
if lhs==1 then
  write(logfile,['No Scilab equivalent to lu called with a single lhs argument';
                '    call replaced by ''mtlb_lu('+s(1)+')'])
  stk=list('mtlb_lu('+s(1)+')','0',s(3),s(4),'1','?')
elseif lhs==2 then
  stk=list(list('lu('+s(1)+')','-1',s(3),s(4),'1','?'),..
           list('lu('+s(1)+')','-1',s(3),s(4),'1','?'))
else
  r= list('lu('+s(1)+')','-1',s(3),s(4),'1','?')   
  stk=list(r,r,r)     
end

