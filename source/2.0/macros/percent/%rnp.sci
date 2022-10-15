//[r]=%rnp(l1,l2)
//%rnp(l1,l2) correspond a l'operation l1<>l2  l1 fraction  rationnelle 
//et l2  matrice de polynome
//!
r=degree(l1(3))==0
if r then r=l1(2)./coeff(l1(3))==l2,end
r=~r
//end


