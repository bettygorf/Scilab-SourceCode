function y=kpure(n)
//!
// Copyright INRIA
y=[],
if type(n)<>16 then error(92,1),end;
flag=n(1);
if flag(1)=='lss' then n=ss2tf(n),end
if flag(1)<>'r' then  error(90,1),end;
if n(4)<>'c' then error('System must be continuous'),end
if size(n(2),'*') > 1 then error(95,1),end

r=routh_t(n,poly(0,'k')),
[n,d]=n(2:3)
[s,t]=size(r);
for i=1:s,
  coe=coeff(r(i,:)),
  if coe==0*ones(1,t) then error('---> infinite solution'),end
end,

z=0;u=0;eps=1e-7;

for i=1:s,
  t=prod(size(r(i,:)));
  gd=r(i,1);
  for j=2:t, 
    [gd,u]=bezout(gd,r(i,j)), 
  end
  k=roots(gd)

  h=prod(size(k)),
  if h>0 then
    for j=1:h,
      if mini(abs(real(roots(k(j)*n+d))))<eps then 
	y=[y real(k(j))],
      end
    end,
  end;
end;

y=sort(y)

