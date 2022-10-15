function [a,b1,b2,c1,c2,d11,d12,d21,d22]=smga(slp,r)
//Matrix extractions (for use with H_inf,lft and other);
// Utility function
//!
if slp(1)='lss' then
       p=r(2),r=r(1),
       [s1,s2,t]=size(slp);
       [a,b,c,d]=slp(2:5),
       b1=b(:,1:s2-p),b2=b(:,s2-p+1:s2),
       c1=c(1:s1-r,:),c2=c(s1-r+1:s1,:),
       d11=coeff(d(1:s1-r,1:s2-p)),
       d12=coeff(d(1:s1-r,s2-p+1:s2)),
       d21=coeff(d(s1-r+1:s1,1:s2-p)),
       d22=d(s1-r+1:s1,s2-p+1:s2)
end
if slp(1)='r' then
   [nl,nk]=size(slp);
   k1=1:nl-r(1);
   k2=nl-r(1)+1:nl;
   m1=1:nk-r(2);
   m2=nk-r(2)+1:nk;
   A=slp(k1,m1); //P11
   B1=Slp(k1,m2); //P12
   B2=Slp(k2,m1); //P21
   C1=Slp(k2,m2); //P22
end


