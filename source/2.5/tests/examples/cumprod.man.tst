clear;lines(0);
A=[1,2;3,4];
cumprod(A)
cumprod(A,'r')
cumprod(A,'c')
rand('seed',0);
a=rand(3,4);
[m,n]=size(a);
w=zeros(a);
w(1,:)=a(1,:);
for k=2:m;w(k,:)=w(k-1,:).*a(k,:);end;w-cumprod(a,'r')
