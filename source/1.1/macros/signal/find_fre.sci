function [m]=find_freq(epsilon,A,n)
//Search for m such that n=K(1-m1)K(m)/(K(m1)K(1-m))
//with m1=(epsilon*epsilon)/(A*A-1);
//If  m = omegar^2/omegac^2,the parameters
//epsilon,A,omegac,omegar and n are then
//compatible for defining a prototype elliptic filter.
//  epsilon :Passband ripple
//  A       :Stopband attenuation
//  n       :filter order
//  m       :Frequency needed for construction of
//          :elliptic filter
//
//!
//Author F.D.
 
   m1=(epsilon*epsilon)/(A*A-1);
   chi1=%K(1-m1)/%K(m1);
   m=findm(chi1/n);
 
function [m]=findm(chi)
//Search for m such that chi = %k(1-m)/%k(m)
//!
//Author F.D.
 
   if chi < 1 then,
      t=1;
      tn=2;
      m=0.9999999;
      mn=2;
      v=16*exp(-%pi/chi);
      while abs(t-tn) > %eps,
         t=tn;
         lln=log(16/(1-m));
         k1=%asn(1,1-m);
         k=%asn(1,m);
         y=(k1*lln/%pi)-k;
         mn=m;
         m=1-v*exp((-%pi*y)/k1);
         tn=m+mn;
      end,
   else,
      t=1;
      tn=2;
      m=0.000001;
      mn=0.1;
      v=16*exp(-%pi*chi);
      while abs(t-tn) > %eps,
         t=tn;
         lln=log(16/m);
         k1=%asn(1,1-m);
         k=%asn(1,m);
         y=(k*lln/%pi)-k1;
         mn=m;
         m=v*exp((-%pi*y)/k);
         tn=m+mn;
      end,
   end

