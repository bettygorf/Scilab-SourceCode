function s=%sasp(a,b)
// %sasp - adds a  scalar a and a sparse matrix b
//!
if size(a)==[-1,-1] then
  //eye+b
  [m,n]=size(b)
  s=(0+a)*speye(m,n)+b
else
  s=a+full(b)
end

