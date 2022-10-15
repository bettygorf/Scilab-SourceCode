//<f]=%pfr(m,f)
// %pfr(m,f) retourne la concatenation d'une matrice de polynomes m et
//et d'une matrice de fractions rationnelles f
//Cette macro correspond a l'operation  [m;f]
//!
[t,n1,d1]=f(1:3),
[p,q]=size(m),
f=list(t,[m;n1],[ones(p,q);d1],f(4)),
//end


