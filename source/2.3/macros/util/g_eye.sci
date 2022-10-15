function x=g_eye(a)
// only to be called by function eye
//!
select type(a)
case 1 then
  x=eye(a)
case 2 then 
  x=eye(a)
case 5 then 
  [m,n]=size(a)
  x=sparse([],[],[m,n])
  
//-compat next case retained for list/tlist compatibility
case 15 then
  a1=a(1)
  if a1(1)=='r' then
    x=eye(a(2));
  elseif a1(1)='lss' then
    x=eye(a(5))
  end
case 16 then
  a1=a(1);
  if a1(1)=='r' then
    x=eye(a(2));
  elseif a1(1)='lss' then
    x=eye(a(5))
  end  
case 10 then
  [m,n]=size(a)
  x=eye(m,n)
else
  error(43)
end
