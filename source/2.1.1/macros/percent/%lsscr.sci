//<s>=%lsscr(s1,s2)
//<s>=%lsscr(s1,s2) calcule la concatenation d'un systeme lineaire decrit
//par sa representation d'etat s1 et d'une matrice de transfert s2.
//  u=[u1;u2]    y=y1+s2*u1
//Cette macro correspond a l'operation  <s1,s2>
//!
// origine s. steer inria 1988
//
[s1,s2]=sysconv(s1,s2);s=[s1,s2];
//end


