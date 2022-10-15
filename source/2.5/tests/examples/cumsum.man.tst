clear;lines(0);
A=[1,2;3,4];
cumsum(A)
cumsum(A,'r')
cumsum(A,'c')
a=rand(3,4)+%i;
[m,n]=size(a);
w=zeros(a);
w(1,:)=a(1,:);
for k=2:m;w(k,:)=w(k-1,:)+a(k,:);end;w-cumsum(a,'r')
