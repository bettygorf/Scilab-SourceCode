function r=routh_t(h,k)
//r=routh_t(h,k) computes routh table of denominator of the
//system described by transfer matrix SISO continue h with the
//feedback by the gain k
//If  k=poly(0,'k') we will have a polynomial matrix with dummy variable 
//k, formal expression of the Routh table.
//r=routh_t(d) computes Routh table of h.
//!
[lhs,rhs]=argn(0)
if rhs=2 then
  
  //-compat type(h)<>15 retained for list/tlist compatibility
   if type(h)<>15&type(h)<>16 then
     error('first argument must be rational')
   end;
   if h(1)<>'r' then
     error('first argument must be rational')
   end;
   [n,d]=h(2:3)
   nd=maxi([degree(d) degree(n)])+1;
   if int(nd/2)<>nd/2 then nd=nd+1,end
   d=coeff(d,0:nd-1);n=coeff(n,0:nd-1);
   //
   d=d+k*n
          else
   if type(h)>2 then error('argument must be polynomial'),end
   nd=degree(h);if int(nd/2)<>nd/2 then nd=nd+1,end
   d=coeff(d,0:nd-1)
end;
//
r=[d(nd:-2:1);d(nd-1:-2:1)]
//
l2=nd/2
for i=3:l2+1
 r(i,1:l2-i+2)=[r(i-1,1),-r(i-2,1)]*r(i-2:i-1,2:l2-i+3)
end;



