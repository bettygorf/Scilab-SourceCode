function x=g_det(a)
// only to be called by function det
//!
select type(a)
case 2 then 
  x=determ(a)
  
//-compat next case retained for list/tlist compatibility
case 15 then
  if a(1)=='r' then
    x=detr(a);
  else
    error(43)
  end
case 16 then
  if a(1)=='r' then
    x=detr(a);
  else
    error(43)
  end
else
  error(43)
end
