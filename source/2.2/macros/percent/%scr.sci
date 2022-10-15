//<f>=%scr(m,f1)
// %scr(M,r) calcule le resultat de la concatenation en ligne d'une
//matrice de scalaires M et d'une matrice de fractions rationnelles. [M,r]
//!
[n1,d1]=f1(2:3)
[p,q]=size(m)
f=tlist('r',[m n1],[ones(p,q),d1],f1(4))
//end


