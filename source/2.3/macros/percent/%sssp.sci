function s=%sssp(a,b)
// %sssp - substract a sparse matrix b to a scalar matrix a
//!
if size(a)==[-1,-1] then
  //eye+b
  [m,n]=size(b)
  s=(0+a)*speye(m,n)-b
else
  s=a-full(b)
end

