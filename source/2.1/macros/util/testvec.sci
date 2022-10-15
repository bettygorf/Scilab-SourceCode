function [y]=testvec(x,car)
   [o,i]=argn(0);
   if i < 2 then error(58); end;
   if type(x) <> 1 then  error(53,1); end;
   if type(car) <> 10 then  error(53,2); end;
//
   sx=size(x);
   select car
     case 'l' then
       if sx(1,1) <> 1 then
         if sx(1,2) = 1 then y=x'; else error(89,1); end;
       else y=x; end;
     case 'r' then
       if sx(1,1) <> 1 then
         if sx(1,2) = 1 then y=x'; else error(89,1); end;
       else y=x; end;
     case 'c' then
       if sx(1,2) <> 1 then
         if sx(1,1) = 1 then y=x'; else error(89,1); end;
       else y=x; end;
     else error(36,2);
   end;



