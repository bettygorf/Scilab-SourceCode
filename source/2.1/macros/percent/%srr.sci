//<f>=%srr(m,f)
// %srr(m,r) calcule la division a droite de la matrice de  scalaires  m
//par la matrice de fractions rationnelles f (M/f)
//!
if prod(size(f(2)))<>1 then f=m*invr(f),return,end
[l,c]=size(m);
f=simp(list('r',m*f(3),ones(l,c)*f(2),f(4)))
//end


