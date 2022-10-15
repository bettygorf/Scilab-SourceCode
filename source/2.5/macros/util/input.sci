function [x]=input(message,flag)
// Copyright INRIA
[LHS,RHS]=argn(0)
if RHS==1 then
disp(message)
x=evstr(read(%io(1),1,1,'(a)'))
end
if RHS==2 then
disp(message)
x=read(%io(1),1,1,'(a)')
end
