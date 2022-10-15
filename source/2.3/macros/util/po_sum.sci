function a=po_sum(a,flag)
[m,n]=size(a);
if flag==1|flag=='r' then
  a=a*ones(n,1);
end
if flag==2|flag=='c' then
  a=ones(1,m)*a;
end
