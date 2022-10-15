function a=%sisp(i,j,b,a)
// %spis(i,j,b,a) insert full matrix b into sparse matrix a
// a(i,j)=b
//!
if b==[] then
  pause
  a=a(:);
end
