//[r]=%snr(l1,l2)
//%snr(l1,l2) correspond a l'operation l1<>l2 ou l1 est une matrice de scalaire
// et l2 une fraction rationnelle 
//!
r=degree(l2(2))==0&degree(l2(3))==0
if r then r=coeff(l2(2))./coeff(l2(3))==l1,end
r=~r
//end


