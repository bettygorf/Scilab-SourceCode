//<f2>=%psr(n1,f2)
// %psr(n1,f2) calcule la soustraction de la matrice de polynome n1 et
//de la matrice de fractions rationnelles f2.
//Cette macro correspond a l'operation   n1-f2
//!
[n2,d2]=f2(2:3),
[n2,d2]=simp(n1.*d2-n2,d2)
f2(2)=n2;f2(3)=d2;
//end


