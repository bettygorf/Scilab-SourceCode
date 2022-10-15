function [stk,txt,top]=sci_clear()
// Copyright INRIA
txt=[]
vars=[]
for k=1:rhs
  vars=[stk(top)(1),vars]
  top=top-1
end
stk=list('clear('+makeargs(vars)+')','0','0','0','1')
