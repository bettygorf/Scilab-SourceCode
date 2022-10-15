function f=%prr(m,f)
// f=%prr(p1,p2) <=> f= p1*(p2^(-1)) 
// p1 polynomial matrix
// p2: rational matrix
//!
if prod(size(f(2)))<>1 then f=m*invr(f),return,end
[l,c]=size(m);
[num,den]=f(2:3)
f(2)=m*den,f(3)=ones(l,c)*num



