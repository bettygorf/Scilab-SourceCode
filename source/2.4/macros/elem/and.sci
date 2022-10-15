function [x]=and(a)
// Logical and. A is a matrix of booleans or a real matrix.
// Returns True or non-zero entries.
//!
// Copyright INRIA
select type(a)
case 1 then
  k=find(abs(a)==0)
case 4 then
  k=find(a==%f)
case 6 then
  k=find(a)
  if size(k,'*')==size(a,'*') then x=%t,return,end
else
  error('input must be boolean or real matrix!')
end
x=k==[]

