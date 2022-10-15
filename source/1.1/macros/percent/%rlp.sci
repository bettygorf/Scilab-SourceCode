//<f>=%rlp(f,m)
// %rlp(f,p) calcule la division a gauche de la matrice de fractions
//rationnelles f et de la matrice de polynomes m (f\p)
//!
if prod(size(f(2)))<>1 then f=invr(f)*m,return,end
[l,c]=size(m);
num=m*f(3);den=ones(l,c)*f(2);f(2)=num;f(3)=den;
//end


