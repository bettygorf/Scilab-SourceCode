//[f]=%sfr(m,f1)
// %sfr(M,r) calcule le resultat de la concatenation en ligne d'une
//matrice de scalaires M et d'une matrice de fractions rationnelles. [M;r]
//!
[t,n1,d1]=f1(1:3)
[p,q]=size(m)
f=list(t,[m;n1],[ones(p,q);d1],f1(4))
//end


