function [stk,txt,top]=sci_exist()
// Copyright INRIA
txt=[]
write(logfile,'Warning: Not enough information using mtlb_exist instead of exists')
stk=list('mtlb_exist('+stk(top)(1)+')','0','1','1','1')
