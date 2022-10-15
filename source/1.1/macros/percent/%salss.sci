//<s>=%salss(d1,s2)
//<s>=%salss(d1,s2)  calcule la mise en parallele d'une matrice de gain
//d1 et d'un systeme lineaire decrit par sa representation d'etat s2.
//Le systeme resultant admet pour sortie la somme des sorties de  s1 et
//d2.  y= s1*u+d2*u
//Cette macro correspond a l'operation  s=d1+s2
//!
// origine s. steer inria 1987
//
[a2,b2,c2,d2,x2,dom2]=s2(2:7)
s=list('lss',a2,b2,c2,d1+d2,x2,dom2)
//end


