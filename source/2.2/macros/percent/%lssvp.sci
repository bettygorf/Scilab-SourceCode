//[sr]=%lssvp(s,p)
// Mise en feedback sr=(eye+s*p)\s
//s=%lssvp(s,p) ou sr=s/.p
// p : matrice de polynomes
// s : representation d'etat d'un systeme lineaire
//!
//origine S Steer INRIA 1992
sr=s/.tlist('lss',[],[],[],p,[],[])
//end
