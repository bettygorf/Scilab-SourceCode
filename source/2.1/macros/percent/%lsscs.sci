//<s>=%lsscs(s1,d2)
//<s>=%lsscs(s1,d2) calcule la concatenation d'un systeme lineaire decrit
//par sa representation d'etat s1 et d'une matrice de gain d2.
//  u=[u1;u2]    y=y1+d2*u1
//Cette macro correspond a l'operation  s=<s1,d2>
//!
// origine s. steer inria 1987
//
[a1,b1,c1,d1,x1,dom1]=s1(2:7)
[n1,m1]=size(b1);[p2,m2]=size(d2);
s=list('lss',a1,[b1 0*ones(n1,m2)],c1,[d1 d2],x1,dom1)
//end


