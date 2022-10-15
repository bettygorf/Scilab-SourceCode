//<f1>=%plr(p1,f1)
// %plr(p1,f1) calcule la division a gauche de la matrice de fractions
//rationnelles f1 par le polynome ou la matrice de polynomes p1.
//Cette macro correspond a l'operation  p1\f1.
//!
[l,c]=size(p1),
if l*c<>1 then f1=invr(p1)*f1,return,end,
[n1,d1]=f1(2:3),
[n1,d1]=simp(n1,p1*d1),
f1(2)=n1;f1(3)=d1;
//end


