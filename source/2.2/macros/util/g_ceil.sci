function x=g_ceil(a)
// only to be called by function ceil
//!
select type(a)
case 2 then 
  x=ceil(a)
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
