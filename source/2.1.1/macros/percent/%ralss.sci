//<s>=%ralss(s1,s2)
//<s>=%ralss(s1,s2) calcule la mise en parallele d'une matrice de trans-
//fert s1 et d'un systeme lineaire decrit par sa  representation d'etat
//s2. Le systeme resultant admet pour sortie la somme des sorties de s1
//et s2.  y= s1*u+s2*u
//Cette macro correspond a l'operation  s=s1+s2
//!
// origine s. steer inria 1988
//
[s1,s2]=sysconv(s1,s2);s=s1+s2;
//end


