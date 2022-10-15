function [x]=and(a)
// Logical and. A is a matrix of booleans or a real matrix.
// Returns True or non-zero entries.
//!
select type(a)
case 1 then
  k=find(abs(a)==0)
case 4 then
  k=find(a==%f)
else
  error('input must be boolean or real matrix!')
end
x=k==[]

