function [y]=test2p(n)
//!
// Copyright INRIA
[o,i]=argn(0);
   if i < 1 then error(58); end;
   if type(n) <>1 then error(53,1); end;
   if size(n) <> [1 1] then error(89,1); end;
//
   if n < 1 then y=1;
   else
     p=log(n)/log(2);
     rp=1 - p + int(p);
     if rp < 1e-7 then p=int(p)+1; else p=int(p); end;
     r=n-2**p;
     if r <= 1e-7 then y=0; else y=1; end;
   end;



