function x=%spls(a,b)
// a\b , a sparse b full
[ma,na]=size(a)
[mb,nb]=size(b)
if mb*nb==1 then x=a\(b*speye(na,na)),return;end
//if ma*na==1 then x=full(a)\b,return,end //hard coded case
if ma<>mb then error(12),end
if ma<>na then b=a'*b;a=a'*a;end
[h,rk]=lufact(a)
if rk<mini(ma,na) then warning('deficient rank: rank = '+string(rk)),end
x=[]    
for k=1:nb
  x=[x,lusolve(h,b(:,k))]
end
ludel(h)


