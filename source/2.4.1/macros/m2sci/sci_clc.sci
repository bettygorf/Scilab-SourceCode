function [stk,txt,top]=sci_clc()
// Copyright INRIA
txt=['//! clc ignored'
    '// clc']
write(logfile,'clc ignored at line '+string(lcount))
stk=list(' ','-2','0','0','1')


