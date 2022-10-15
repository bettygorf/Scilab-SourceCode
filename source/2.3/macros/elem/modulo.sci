function [i]=modulo(n,m)
//i=modulo(n,m) returns  n modulo m.
//!
if size(m,'*')==1 then 
  m=ones(n)*m,
elseif size(n,'*')==1 then 
  n=ones(m)*n,
end
i=n-int(n./m).*m
// n - m .* fix (n ./ m)


