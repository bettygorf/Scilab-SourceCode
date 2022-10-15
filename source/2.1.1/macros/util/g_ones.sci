function x=g_ones(a)
// only to be called by function ones
//!
select type(a)
case 1 then
  x=ones(a)
case 2 then 
  x=ones(a)
case 15 then
  if a(1)=='r' then
    x=ones(a(2));
  elseif a(1)='lss' then
    x=ones(a(5))
  end
case 10 then
  [m,n]=size(a)
  x=ones(m,n)
else
  error(43)
end
