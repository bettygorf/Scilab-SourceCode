function r=mtlb_ifft(x,n)
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs==2 then
  s=size(x,'*')
  if s>n then //truncated ifft
    x=x(1:n)
  elseif s<n then //padd with zeros
    x(n)=0
  end
  r=fft(x,1)
else
  //column wise ifft
  r=[]
  for xk=x
    r=[r fft(xk,1)]
  end
end

