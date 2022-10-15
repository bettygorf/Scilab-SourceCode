//[r]=%rop(l1,l2)
//%rop(l1,l2) correspond a l'operation l1==l2 ou l1 est une fraction
// rationnelle et l2 une matrice de scalaire
//!
r=degree(l1(3))==0
if r then r=l1(2)./coeff(l1(3))==l2,end
//end


