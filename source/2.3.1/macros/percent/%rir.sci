function s1=%rir(i,j,s1,s2)
// %rir(i,j,s1,s2) insertion  s2(i,j)=s1
//!
if type(i)==10|type(j)==10 then 
  error(21)
end
if type(i)==4 then i=find(i),end
if type(j)==4 then j=find(j),end

[s1,s2]=sysconv(s1,s2)
[n,d]=s2(2:3)
[n1,n2]=size(d);
if type(i)<>1 then i=horner(i,n1),end
if type(j)<>1 then j=horner(j,n2),end
if size(i)<>[-1,-1] then 
  n3=maxi([n1,maxi(i)]); 
else 
  n3=n1; 
end
if size(j)<>[-1,-1] then 
  n4=maxi([n2,maxi(j)]) 
else 
  n4=n2 
end
d1=ones(n3,n4);
d1(1:n1,1:n2)=d;
n(i,j)=s1(2),d1(i,j)=s1(3)
s1(2)=n;s1(3)=d1;



