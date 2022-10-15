function [y]=intersp(s,nint)
   [o,i]=argn(0);
   if i <> 2 then error(58); end;
   if type(s) <> 1 then error(53,1); end;
   if type(nint) <> 1 then error(53,2); end;
   if maxi(size(s)) = 1 then error(89,1); end;
   if nint <= 1 then error(36,1); end;
//
   M=prod(size(s));
   x=(0:M-1)/(M-1);
   xd=(0:nint-1)/(nint-1);
   d=splin(x,s);
   y=interp(xd,x,s,d);



