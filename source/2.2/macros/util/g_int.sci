function x=g_int(a)
// only to be called by function int
//!
select type(a)
case 2 then 
  x=int(a)
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
else
  error(43)
end
