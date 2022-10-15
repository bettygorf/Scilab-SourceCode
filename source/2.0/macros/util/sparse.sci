function [sp]=sparse(values,ij,nrows,ncols)
[lhs,rhs]=argn(0)
[n,two]=size(ij);
if two~=2 then error("bad call to sparse (2nd argument)");end 
if rhs==4 then
  sp=list('sp',values,ij,nrows,ncols);
  return;
end
if rhs==2 then
  nrows=maxi(ij(:,1));ncols=maxi(ij(:,2));
  sp=list('sp',values,ij,nrows,ncols);
  return;
end
error("bad call to sparse: 2 or 4 arguments");
