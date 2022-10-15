function [x]=or(a)
// and(a) returns the logical OR
// for scalar matrices, an entry is TRUE if it is not zero.
//!
// Copyright INRIA
select type(a)
case 1 then
  k=find(abs(a)>0)
case 4 then
  k=find(a)
case 6 then
  k=find(a)
else
  error('argument must be a boolean or a real matrix!')
end
x=k<>[]

