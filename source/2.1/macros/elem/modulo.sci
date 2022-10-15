function [i]=modulo(n,m)
//i=modulo(n,m) returns  n modulo m.
//!
if prod(size(m))==1 then 
  m=ones(n)*m,
elseif prod(size(n))==1 then 
  n=ones(m)*n,
end
i=n-int(n./m).*m
// n - m .* fix (n ./ m)


