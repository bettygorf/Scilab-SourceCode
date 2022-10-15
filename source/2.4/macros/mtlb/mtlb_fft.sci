function r=mtlb_fft(x,n,job)
// Copyright INRIA
[lhs,rhs]=argn(0)
if n<>[] then
  s=size(x,'*')
  if s>n then //truncated fft
    x=x(1:n)
  elseif s<n then //padd with zeros
    x(n)=0
  end
  r=fft(x,job)
else
  //column wise fft
  r=[]
  for xk=x
    r=[r fft(xk,job)]
  end
end

