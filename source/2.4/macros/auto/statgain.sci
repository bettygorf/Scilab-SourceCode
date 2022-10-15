function st=statgain(sl)

// Copyright INRIA
//-compat type(sl)<>15 retained for list/tlist compatibility
if type(sl)<>15&type(sl)<>16 then error(97,1),end
flag=sl(1);
select flag(1)
 case 'lss'
   dom=sl(7);
   [m,p]=size(sl(2));
   if dom=='c' then
     if rank(sl(2)) <> m then error('singular A matrix'),end
     st=sl(5)-sl(4)*inv(sl(2))*sl(3);
              else
     if rank(eye(m,m)-sl(2))<>m then error('singular eye-a matrix'),end
     st=sl(5)+sl(4)*inv(eye(m,m)-sl(2))*sl(3);
   end;
 case 'r' then
   dom=sl(4)
   if dom=='c' then
     st=freq(sl(2),sl(3),0)
              else
     st=freq(sl(2),sl(3),1)
   end;
 else  error(97,1)
end;



