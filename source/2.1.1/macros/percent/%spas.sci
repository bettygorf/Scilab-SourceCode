function s=%spas(a,b)
// %spas - adds a sparse matrix and a scalar s
//!
if size(b)==[-1 -1] then
  [m,n]=size(a)
  s=a+(b+0)*speye(m,n)
else
  s=full(a)+b
end
