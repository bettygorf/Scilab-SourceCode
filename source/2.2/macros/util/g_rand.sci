function x=g_rand(a)
// only to be called by function rand
//!
select type(a)
case 1 then
  x=rand(a)
case 2 then 
  x=rand(a)
  
//-compat next case retained for list/tlist compatibility
case 15 then
  if a(1)=='r' then
    x=rand(a(2));
  elseif a(1)='lss' then
    x=rand(a(5))
  end
case 16 then
  if a(1)=='r' then
    x=rand(a(2));
  elseif a(1)='lss' then
    x=rand(a(5))
  end  
case 10 then
  [m,n]=size(a)
  x=rand(m,n)
else
  error(43)
end
