function [num]=numer(r)
//returns the numerator num of a rational function matrix r (r may be
//also a scalar or polynomial matrix
//!
select type(r)
case 1 then
  num=r;
case 2 then
  num=r;
case 15 then
  if r(1)<>'r' then error(92,1),end
  num=r(2)
else
  error(92,1)
end

