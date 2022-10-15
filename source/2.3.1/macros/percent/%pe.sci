function f=%pe(i,j,f)
// f=%pe(i,j,f) <=> f=f(i,j) , i,j integers (or booleans f(i,j) is f(find(i),find(j))
//!
[lhs,rhs]=argn(0)
if rhs==2 then
  if type(i)==4 then i=find(i),end
  f=j(i)
else
  if type(i)==4 then i=find(i),end
  if type(j)==4 then j=find(j),end
  f=f(i,j)
end


