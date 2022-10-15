function x=g_rand(a)
// only to be called by function rand
//!
// Copyright INRIA
select type(a)
case 1 then
  x=rand(a)
case 2 then 
  x=rand(a)
  
// for list/tlist compatibility
case 15 then
  a1=a(1)
  if a1(1)=='r' then
    x=rand(a(2));
  elseif a1(1)=='lss' then
    x=rand(a(5))
  end
case 16 then
  a1=a(1)
  if a1(1)=='r' then
    x=rand(a(2));
  elseif a1(1)=='lss' then
    x=rand(a(5))
  end  
case 10 then
  [m,n]=size(a)
  x=rand(m,n)
else
  error(43)
end
