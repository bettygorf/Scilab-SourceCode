//<f>=%sar(m,f)
// %sar(m,f)  calcule la somme d'une matrice de fractions rationnelles
//et d'une  matrice de  scalaires ou la  somme d'un  systeme dynamique
//decrit par sa matrice de transfert et d'un gain constant.
//Cette macro correspond a l'operation  m+f
//!
if sum(size(m))=-2 then m=m*eye(f(3)); end;
f(2)=f(2)+m.*f(3);
//end


