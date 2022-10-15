//<s>=%rvlss(s1,s2)
//<s>=%rvlss(s1,s2) calcule le bouclage "feedback" du transfert s1 par
//le systeme lineaire decrit par sa representation d'etat s2.
//Cette macro correspond a l'operation  s1/.s2
//!
// origine s. steer inria 1988
//
[s1,s2]=sysconv(s1,s2);s=s1/.s2;
//end


