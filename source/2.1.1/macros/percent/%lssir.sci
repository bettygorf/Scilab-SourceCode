//[s2]=%lssir(i,j,s1,s2)
//%lssir(i,j,s1,s2) calcule l'insertion d'un sous systeme lineaire
// decrit par une representation d'etat  dans un systeme lineaire
// decrit par sa fonction de transfert
//Cette macro correspond a l'operation  s2(i,j)=s1
//!
// origine s. steer inria 1992
//
[s1 s2]=sysconv(s1,s2)
s2(i,j)=s1
//end


