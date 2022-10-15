//<s>=%lssar(s1,s2)
//<s>=%lssar(s1,s2)  calcule la mise en  parallele d'un systeme  lineaire
//decrit par sa representation d'etat s1 et de la matrice de transfert s2.
//Le systeme resultant admet pour sortie la somme des sorties de s1 et s2.
//  y= s1*u+s2*u
//Cette macro correspond a l'operation s1+s2
//!
// origine s. steer inria 1987
//
[s1,s2]=sysconv(s1,s2);s=s1+s2;
//end


