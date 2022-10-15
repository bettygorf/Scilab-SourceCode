//<s1>=%rqr(s1,s2)
// %rqr(s1,s2) calcule la division a droite de la matrice de fractions
//rationnelles s1 par la matrice de fractions rationnelles s2.
//Cette macro correspond a l'operation  s1.\s2
//!
[s1,s2]=sysconv(s1,s2)
[num,den]=simp(s1(3).*s2(2),s1(2).*s2(3))
s1(2)=num;s1(3)=den;
//end


