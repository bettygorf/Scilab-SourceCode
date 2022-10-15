function t=cos2cosf(u,scs_m,count)
//write scilab instructions whose evaluation 
//returns the  value of scicos data structure scs_m.
// in the opened file associated with logical unit u
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs<3 then 
  count=0,
  lname='scs_m'
else
  count=count+1
  lname='scs_m_'+string(count)
end
bl='   '
lmax=80-3*count
t=lname+'=list()'
t1=sci2exp(scs_m(1),lmax);
t=[t;lname+'(1)='+t1(1);t1(2:$)]
write(u,t,'(a)')

for k=2:size(scs_m)
  t=[];
  o=scs_m(k)
  if o(1)=='Block' then
    model=o(3)
    if model(1)=='super'| model(1)=='csuper' then
      t1=cos2txt(o,count)
      t=[t;bl(ones(t1))+t1;lname+'('+string(k)+')='+'scs_m_'+string(count+1)]
    else
      lhs=lname+'('+string(k)+')='
      t1=sci2exp(o,lmax-length(lhs))
      bl1=' ';bl1=part(bl1,1:length(lhs))
      n1=size(t1,1)
      t=[t;lhs+t1(1);bl1(ones(n1-1,1))+t1(2:$)]
    end
  else
    lhs=lname+'('+string(k)+')='
    t1=sci2exp(o,lmax-length(lhs))
    bl1=' ';bl1=part(bl1,1:length(lhs))
    n1=size(t1,1)
    t=[t;lhs+t1(1);bl1(ones(n1-1,1))+t1(2:$)]
  end
  write(u,t,'(a)')
end
