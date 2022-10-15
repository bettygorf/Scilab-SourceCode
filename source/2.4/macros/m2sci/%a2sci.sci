function [stk,txt,top]=%a2sci()
//
//!
// Copyright INRIA
txt=[]
s2=stk(top);s1=stk(top-1);

if s1(3)=='1'&s1(4)=='1' then
  stk=list(s1(1)+'+'+s2(1),'2',s2(3),s2(4),s1(5))
elseif s2(3)=='1'&s2(4)=='1' then
  stk=list(s1(1)+'+'+s2(1),'2',s1(3),s1(4),s1(5))
else
  stk=list(s1(1)+'+'+s2(1),'2',s1(3),s1(4),s1(5))
end
top=top-1


