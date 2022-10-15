//[s]=%lssrs(s1,d2)
//s=%lssrs(s1,d2)  calcule la mise en serie  d'une matrice de gain 1/d2
//et d'un systeme lineaire decrit par sa representation d'etat s1.
//  --> d2 --> s1 -->
//Cette macro correspond a l'operation  s=s1*d2
//!
// origine s. steer inria 1987
//
[a1,b1,c1,d1,x1,dom1]=s1(2:7)
s=tlist('lss',a1,b1/d2,c1,d1/d2,x1,dom1)
//end


