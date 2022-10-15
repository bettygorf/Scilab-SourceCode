function x=%srsp(a,b)
// a/b , a full b sparse
[ma,na]=size(a)
[mb,nb]=size(b)
if na<>nb then error(12),end
if mb<>nb then
  a=a*b';b=b*b'
end

[h,rk]=lufact(b')
if rk<mini(mb,nb) then warning('deficient rank: rank = '+string(rk)),end
x=[]    
for k=1:ma
  x=[x;lusolve(h,a(k,:)')']
end
ludel(h)
