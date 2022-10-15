//<f>=%rrp(f1,p2)
// %rrp(f,p) calcule la division a droite de la matrice de fractions
//rationnelles f et de la matrice de polynomes p. (f/p)
//!
if prod(size(p2)) <>1 then f=f1*invr(p2),return,end
[t,n1,d1]=f1(1:3)
[n1,p2]=simp(n1,p2*d1)
f=list(t,n1,p2,f1(4))
//end


