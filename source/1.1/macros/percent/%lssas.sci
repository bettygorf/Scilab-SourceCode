//<s>=%lssas(s1,d2)
//<s>=%lssas(s1,d2)  calcule la mise  en parallele d'un  systeme lineaire
//decrit par sa representation d'etat s1 et d'une matrice de gain d2.
//Le systeme resultant admet pour sortie la somme des sorties de s1 et d2.
//  y= s1*u+d2*u
//Cette macro correspond a l'operation  s=s1+d2
//!
// origine s. steer inria 1987
//
[a1,b1,c1,d1,x1,dom1]=s1(2:7)
s=list('lss',a1,b1,c1,d1+d2,x1,dom1)
//end


