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
  if mini(size(x))==1 then
    r=fft(x,job)
  else
    r=[]
    for xk=x
      r=[r fft(xk,job)]
    end
  end  
else
  //column wise fft
  if mini(size(x))==1 then
    r=fft(x,job)
  else
    r=[]
    for xk=x
      r=[r fft(xk,job)]
    end
  end
end

