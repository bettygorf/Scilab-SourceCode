function [y]=kpure(n,d)
//!
y=[],
[lhs,rhs]=argn(0)
if rhs=1 then
   if type(n)<>15 then error(92,1),end;
   if n(1)<>'r' then  error(90,1),end;
   if prod(size(n(2)))>1 then error(95,1),end
   r=routh_t(n,poly(0,'k')),
   [n,d]=n(2:3)
else
   if type(n)>2 then error(54,1),end;
   if type(d)>2 then error(54,2),end;
   if prod(size(n))>1 then error(89,1),end
   if prod(size(d))>1 then error(89,2),end
   r=routh_t(n/d,poly(0,'k'))
end;
[s,t]=size(r);
for i=1:s,
  coe=coeff(r(i,:)),
  if coe=0*ones(1,t) then error('---> infinite solution'),end,
end,
z=0;u=0;eps=1e-7;
for i=1:s,
  //
  t=prod(size(r(i,:)));
  gd=r(i,1);for j=2:t, [gd,u]=bezout(gd,r(i,j)), end,
  k=roots(gd)
  //
  h=prod(size(k)),
  if h>0 then
  for j=1:h,
    if mini(abs(real(roots(k(j)*n+d))))<eps then y=[y real(k(j))],end
  end,
  end;
end;
//
y=sort(y)
ny=prod(size(y))
i1=1;i2=1
while i1<=ny
 if abs(y(i1)-y(i2))<eps then
             i1=i1+1
                         else
             y(i2+1)=y(i1),i2=i2+1,i1=i1+1
 end;
end;
y=y(1:i2)



