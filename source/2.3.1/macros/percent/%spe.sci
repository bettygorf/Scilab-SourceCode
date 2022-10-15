function r=%spe(i,j,a)
// r=a(i,j) for f sparse in some special cases
//!
[lhs,rhs]=argn(0)
if rhs==2 then
  a=j;
  a=a(:)
  r=a(i)
end

