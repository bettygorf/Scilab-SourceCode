//[s]=%pslss(d1,s2)
//s=%pslss(s1,d2) ou s=p-s1
// s1 : systeme donne par sa representation d'etat
// p  : matrice de polynomes
//
//!
// origine S Steer INRIA 1992
//!
 [a2,b2,c2,d2,x2,dom2]=s2(2:7),
 s=tlist('lss',a2,b2,c2,d1-d2,x2,dom2),
//end


