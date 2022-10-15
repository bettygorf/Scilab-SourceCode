function s1=%r_r_r(s1,s2)
// %r_r_r(s1,s2) <=> s1/s2    for rationals
//!
// Copyright INRIA
[s1,s2]=sysconv(s1,s2),
[n,m]=size(s2(2))
if n<>m then error(43),end
if n*m==1 then
  s1=%r_m_r(s1,tlist(['r','num','den','dt'],s2(3),s2(2),s2(4)) ),
else
 p=s2(2)
 s2=s2(3)
 for k=1:n
   pp=lcm(s2(:,k))
   for l=1:n;p(l,k)=p(l,k)*pdiv(pp,s2(l,k)),end
   s1(:,k)=s1(:,k)*pp
 end
 s1=s1*invr(p)
end



