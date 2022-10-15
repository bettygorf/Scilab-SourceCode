//<s>=%lssmr(s1,s2)
//<s>=%lssmr(s1,s2) calcule la mise en serie d'une matrice de transfert
//s2 et d'un systeme lineaire  decrit par sa representation d'etat s1.
//  --> s2 --> s1 -->
//Cette macro correspond a l'operation s2*s1
//!
// origine s. steer inria 1988
//
[s1,s2]=sysconv(s1,s2);s=s1*s2
//end


