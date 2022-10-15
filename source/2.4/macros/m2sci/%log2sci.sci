function [stk,txt,top]=%log2sci()
//
//!
// Copyright INRIA
txt=[]
iop=evstr(op(2))
s2=stk(top);s1=stk(top-1);top=top-1
if s2(2)=='2' then s2(1)='('+s2(1)+')',end
if s1(2)=='2' then s1(1)='('+s1(1)+')',end

// special case for nargout.

if s1(1)=='nargout'&s2(1)=='0' then
  s2(1)='1'
elseif s2(1)=='nargout'&s1(1)=='0' then
  s1(1)='1'
end

if s1(3)=='1'&s1(4)=='1' then
  stk=list(s1(1)+ops(iop,1)+s2(1),'2',s2(3),s2(4),'4')
elseif s2(3)=='1'&s2(4)=='1' then
  stk=list(s1(1)+ops(iop,1)+s2(1),'2',s1(3),s1(4),'4')
else
  stk=list(s1(1)+ops(iop,1)+s2(1),'2',s1(3),s1(4),'4')
end




