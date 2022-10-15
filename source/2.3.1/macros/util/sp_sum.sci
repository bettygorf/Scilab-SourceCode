function a=sp_sum(a,flag)
[m,n]=size(a);
if flag==2|flag=='c' then
  a=a*sparse(spzeros(n,1)+1);
end
if flag==1|flag=='r' then
  a=sparse(spzeros(1,m)+1)*a;
end
