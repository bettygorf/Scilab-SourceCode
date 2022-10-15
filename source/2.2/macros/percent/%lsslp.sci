function [sr]=%lsslp(s,p)
//sr=%lsslp(s,p) <=> sr=s\p
// p matrice de polynomes
// s representation d'etat d'un systeme lineaire
//!
//origine S Steer INRIA 1992
sr=s\tlist('lss',[],[],[],p,[],[])


