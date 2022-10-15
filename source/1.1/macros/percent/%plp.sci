//<f>=%plp(p2,p1)
// %plp(p2,p1) calcule la division a gauche de la matrice de polynomes p2
//par la matrice de polynome ou le polynome p1. Cette macro correspond
//a l'operation p2\p1.
//!
[l,c]=size(p2)
if l*c <>1 then f=invr(p2)*p1,return,end
[l,c]=size(p1)
[p1,p2]=simp(p1,p2*ones(l,c))
f=list('r',p1,p2,[])
//end


