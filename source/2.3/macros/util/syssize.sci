function [io,s]=syssize(sys)
//Old stuff
//  io=syssize(sys)
//  [io,ns]=syssize(sys)
//
//   sys   : syslin list
//   io    : io=[nout,nin] 
//                nout:  nb. ouputs
//                nin :  nb. inputs
//   s    : nb states.
select type(sys)
case 1 then
  io=size(sys)
  s=[]
  
//-compat next case retained for list/tlist compatibility
case 15 then
  sys1=sys(1)
  select sys1(1)
  case 'lss' then
    io=size(sys(5)),
    [s,s]=size(sys(2))
   case 'r' then
    io=size(sys(3))
    [lhs,rhs]=argn(0);
    if lhs=2 then  sys=tf2ss(sys);[s,s]=sys(2),end
   else error(97,1)
   end;
 case 16 then
  sys1=sys(1)
  select sys1(1)
  case 'lss' then
    io=size(sys(5)),
    [s,s]=size(sys(2))
   case 'r' then
    io=size(sys(3))
    [lhs,rhs]=argn(0);
    if lhs=2 then  sys=tf2ss(sys);[s,s]=sys(2),end
   else error(97,1)
   end;   
else
  error(97,1),
end



