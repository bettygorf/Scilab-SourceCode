function x=g_imag(a)
// only to be called by function imag
//!
// Copyright INRIA
select type(a)
case 2 then 
  x=imag(a)
//-compat next case retained for list/tlist compatibility
case 15 then
  if a(1)=='r' then
    error(43)
  else
    error(43)
  end
case 16 then
  if a(1)=='r' then
    error(43)
  else
    error(43)
  end
case 5
  [ij,v,mn]=spget(a)
  x=sparse(ij,imag(v),mn)
else
  error(43)
end
