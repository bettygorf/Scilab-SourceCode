function [stk,txt,top]=sci_echo()
// Copyright INRIA
RHS=[]
for k=1:rhs
  RHS=[RHS stk(top-rhs+k)(1)]
end
txt=['//! echo '+strcat(RHS,' ')+' ignored'
    '// echo '+strcat(RHS,' ')]
write(logfile,'echo '+strcat(RHS,' ')+' ignored at line '+string(lcount))
stk=list(' ','-2','0','0','1')


