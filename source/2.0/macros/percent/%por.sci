//[r]=%por(l1,l2)
//%por(l1,l2) correspond a l'operation l1==l2 l1  matrice de polynomes
// et l2 fraction rationnelle 
//!
r=degree(l2(3))==0
if r then r=l2(2)./coeff(l2(3))==l1,end
//end


