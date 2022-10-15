function f2=%ris(i,j,f2,n)
// %ris(i,j,r,m) 
//!
if type(i)==10|type(j)==10 then error(21),end
[l,c]=size(n),
if type(i)==4 then i=find(i),end
if type(j)==4 then j=find(j),end
if type(i)<>1 then i=horner(i,n1),end
if type(j)<>1 then j=horner(j,n2),end
if size(i)<>[-1,-1]; l=maxi([l,maxi(i)]); end;
if size(j)<>[-1,-1]; c=maxi([c,maxi(j)]); end;
d=ones(l,c);
n(i,j)=f2(2),d(i,j)=f2(3)
f2(2)=n;f2(3)=d;



