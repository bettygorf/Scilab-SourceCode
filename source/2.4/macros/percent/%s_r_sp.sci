function x=%s_r_sp(a,b)
// a/b , a full b sparse
// Copyright INRIA
[ma,na]=size(a)
[mb,nb]=size(b)
if ma*na==1 then x=(a*speye(nb,nb))/b,return;end
//if mb*nb==1 then x=a/full(b),return,end //hard coded case
if na<>nb then error(11),end

if mb<>nb then a=a*b';b=b*b';end

[h,rk]=lufact(b')
if rk<mini(mb,nb) then warning('deficient rank: rank = '+string(rk)),end
x=[]    
for k=1:ma
  x=[x;lusolve(h,a(k,:)')']
end
ludel(h)
