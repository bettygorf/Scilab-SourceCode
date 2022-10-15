function p=syspoles(sys)
select type(sys)
case 1 then
  p=[]
case 2 then 
  p=[]
  
//-compat next case for list/tlist compatibility
case 15 then
  select sys(1)
  case 'r' then
    if prod(size(sys(3)))==1 then
      p=roots(sys(3))
    else
      sys=tf2ss(sys)
      p=spec(sys(2))
    end
  case 'lss'
    p=spec(sys(2))
  else
    error(97,1)
  end 
case 16 then
  select sys(1)
  case 'r' then
    if prod(size(sys(3)))==1 then
      p=roots(sys(3))
    else
      sys=tf2ss(sys)
      p=spec(sys(2))
    end
  case 'lss'
    p=spec(sys(2))
  else
    error(97,1)
  end   
else
  error(97,1)
end

