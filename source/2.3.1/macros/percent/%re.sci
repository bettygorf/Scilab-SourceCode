function [f1,f2,f3,f4,f5]=%re(i,j,f)
// %re(i,j,f) extraction f(i,j) in a rational matrix
//!
if type(i)==10 then
  [lhs,rhs]=argn(0)
  if rhs<>2 then  error(21),end
  nams=['num','den','dt']
  for k=1:prod(size(i))
    kf=find(i(k)==nams)
    if kf==[] then error(21),end
    execstr('f'+string(k)+'=j(kf+1)')
  end
  return
end
if type(i)==4 then i=find(i),end
if type(j)==4 then j=find(j),end

f1=f;
[n,d]=f1(2:3)
f1(2)=n(i,j);f1(3)=d(i,j)
if f1(3)==[] then f1=[],end
