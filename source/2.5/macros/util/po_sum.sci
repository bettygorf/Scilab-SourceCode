function a=po_sum(a,flag)
// Copyright INRIA
[m,n]=size(a);
if flag==1|flag=='r' then
  a=ones(1,m)*a;
end
if flag==2|flag=='c' then
  a=a*ones(n,1);
end
