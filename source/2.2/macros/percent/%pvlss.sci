//[sr]=%pvlss(p,s)
// Mise en feedback sr=(eye+p*s)\p
//s=%pvlss(p,s) ou sr=p/.s
// p : matrice de polynomes
// s : representation d'etat d'un systeme lineaire
//!
//origine S Steer INRIA 1992
sr=tlist('lss',[],[],[],p,[],[])/.s
//end
