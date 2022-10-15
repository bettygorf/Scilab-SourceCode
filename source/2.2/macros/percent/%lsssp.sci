//[s]=%lsssp(s1,d2)
//s=%lsssp(s1,d2) ou s=s1-p
// s1 : systeme donne par sa representation d'etat
// p  : matrice de polynomes
//
//!
// origine S Steer INRAI 1992
 [a1,b1,c1,d1,x1,dom1]=s1(2:7),
 s=tlist('lss',a1,b1,c1,d1-d2,x1,dom1),
//end


