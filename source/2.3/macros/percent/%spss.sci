function s=%spss(a,b)
// %spss - substract a scalar b to a sparse matrix a
//!
if size(b)==[-1 -1] then
  [m,n]=size(a)
  s=a-(b+0)*speye(m,n)
else
  s=full(a)-b
end
