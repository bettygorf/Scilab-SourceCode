function [stk,txt,top]=sci_reshape()
// Copyright INRIA
txt=[]
RHS=rhsargs([stk(top-2)(1),stk(top-1)(1),stk(top)(1)])
stk=list('matrix'+RHS,'0',stk(top-1)(1),stk(top)(1),'1')
top=top-2
