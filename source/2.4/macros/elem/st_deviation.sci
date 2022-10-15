function y=st_deviation(x,orient)
// Copyright INRIA
[lhs,rhs]=argn(0)
if x==[] then y=%nan;return,end
if rhs==1 then
  n=size(x,'*')
  y=norm(x-sum(x)/n)
  if n>1 then y = y / sqrt(n-1);end
elseif orient=='r'|orient==1 then
  [m,n]=size(x)
  y=sum(x,'r')/m
  for l=1:n
    y(l) = norm(x(:,l)-y(l));
  end
  if m>1 then y = y / sqrt(m-1);end
elseif orient=='c'|orient==2 then
  [m,n]=size(x)
  y=sum(x,'c')/n
  for k=1:m
    y(k) = norm(x(k,:)-y(k));
  end  
  if n>1 then y = y / sqrt(n-1);end
else  
  error('mean : second argument must be ''r'', ''c'', 1 or 2')
end

