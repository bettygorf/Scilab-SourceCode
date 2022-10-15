function x=g_ones(a)
// only to be called by function ones
//!
select type(a)
case 1 then
  x=ones(a)
case 2 then 
  x=ones(a)
  
//-compat next case retained for list/tlist compatibility
case 15 then
  a1=a(1)
  if a1(1)=='r' then
    x=ones(a(2));
  elseif a1(1)='lss' then
    x=ones(a(5))
  end
case 16 then
  a1=a(1)
  if a1(1)=='r' then
    x=ones(a(2));
  elseif a1(1)='lss' then
    x=ones(a(5))
  end  
case 10 then
  [m,n]=size(a)
  x=ones(m,n)
else
  error(43)
end
