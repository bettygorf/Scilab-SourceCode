function [phi,db]=phasemag(z,mod)
//
// Copyright INRIA
mod_def='c'     //continuous representation
//mod_def='m'   //representation modulo 360 degrees
[lhs,rhs]=argn(0)
if lhs==2 then 
  db=20*log(abs(z))/log(10),
end
if rhs<>2 then 
  mod=mod_def
end
phi1=atan(-imag(z(:,1)),-real(z(:,1)))
[m,n]=size(z)
z=z(:,2:n)./z(:,1:n-1)
phi=[phi1 atan(imag(z),real(z))]
if n>1 then
for l=1:m
  kk=find(abs(phi(l,2:n)-phi(l,1:n-1))>=2*%pi)
  if kk<>[] then
    phi(l,kk+ones(kk))=phi(l,kk)
  end
end
end

for k=2:n
  phi(:,k)=phi(:,k)+phi(:,k-1)
end
phi=phi*(180/%pi)-180*ones(phi)
//reset modulo 360
if part(mod,1)=='c' then
  mphi=maxi(phi)
  k=int(mphi/360)
  if mphi>0 then k=k+1,end
  phi=phi-ones(phi)*360*k
else
  for l=1:m
    k=find(phi(l,:)>0)
    phi(l,:)=phi(l,:)-int(phi(l,:)/360)*360
    if k<>[] then phi(l,k)=phi(l,k)-360*ones(k),end
  end
end



