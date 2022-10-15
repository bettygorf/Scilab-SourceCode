//[s]=%pclss(d1,s2)
//s=%pclss(d1,s2)  calcule la concatenation d'une matrice de polynomes  d1
//et d'un systeme lineaire decrit par sa representation d'etat s2.
//  u=[u1;u2]     y=d1*u1+y2
//Cette macro correspond a l'operation  s=[d1,s2]
//!
// origine s. steer inria 1987
//
[a2,b2,c2,d2,x2,dom2]=s2(2:7)
[n2,m2]=size(b2);[p1,m1]=size(d1)
s=list('lss',a2,[0*ones(n2,m1),b2],c2,[d1,d2],x2,dom2)
//end


