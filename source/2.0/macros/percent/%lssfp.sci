//[s]=%lssfp(s1,d2)
//[s]=%lssfp(s1,d2) calcule la concatenation d'un systeme lineaire decrit
//par sa representation d'etat s1 et d'une matrice de polynomes d2.
//     y=[y1;d2*u]
//Cette macro correspond a l'operation  s=[s1;d2]
//!
// origine s. steer inria 1987
//
[a1,b1,c1,d1,x1,dom1]=s1(2:7)
[n1,m1]=size(c1);[p2,m2]=size(d2);
s=list('lss',a1,b1,[c1;0*ones(p2,m1)],[d1;d2],x1,dom1)
//end


