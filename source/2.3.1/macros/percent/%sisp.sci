function a=%sisp(i,j,b,a)
// %spis(i,j,b,a) insert full matrix b into sparse matrix a for some special cases 
// a(i,j)=b
//!
[lhs,rhs]=argn(0)
if rhs==3 then
  a=b;
  b=j;
  [m,n]=size(a)
  a=a(:)
  a(i)=b
end
[ij,v]=spget(a)
j=int(ij(:,1)/m)+1
i=ij(:,1)-m*(j-1)
a=sparse([i j],v,[m,n])


