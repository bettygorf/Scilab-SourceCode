function m = mtlb_mean(x) ;
// Copyright INRIA
[r,c] = size(x) ;
if r == 1
  x = x(:) 
  r = c ;c = 1;
end
m=sum(x,'r')/r
