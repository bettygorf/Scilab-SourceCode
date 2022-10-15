//<f>=%prr(m,f)
// %prr(p1,p2) calcule p1*(p2**(-1)) ou p1 est une matrice de polynomes
//et p2 une matrice de fractions rationelles.
//!
if prod(size(f(2)))<>1 then f=m*invr(f),return,end
[l,c]=size(m);
[num,den]=f(2:3)
f(2)=m*den,f(3)=ones(l,c)*num
//end


