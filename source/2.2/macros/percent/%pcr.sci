function f=%pcr(m,f)
// %pcr(m,f) retourne la concatenation d'une matrice de polynomes m et
//et d'une matrice de fractions rationnelles f
//Cette macro correspond a l'operation  [m,f]
//!
[n1,d1]=f(2:3),
[p,q]=size(m),
f=tlist('r',[m n1],[ones(p,q),d1],f(4)),



