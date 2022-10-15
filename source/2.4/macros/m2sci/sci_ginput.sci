function [stk,txt,top]=sci_ginput()
// Copyright INRIA
txt=[]

if lhs==2 then
  xy=gettempvar(1)
  if rhs<1 then
    txt=xy+' = locate()';
  elseif rhs==1 then
    txt=xy+' = locate('+stk(top)(1)+')';
  end
  stk=list(list(xy+'(1,:)''','0','?','1','1'),..
           list(xy+'(2,:)''','0','?','1','1'))
else
  if rhs<1 then
    RHS=emptystr()
  else
    RHS=stk(top)(1)
  end
  write('logfile','Warning: ginput replaced by mtlb_ginput')
  r=list('mtlb_ginput('+makeargs(RHS)+')','-1','?','1')
  stk=list(r,r,r)
end
