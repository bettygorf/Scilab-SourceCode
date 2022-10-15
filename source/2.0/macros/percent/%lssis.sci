//[s]=%lssis(i,j,s1,s2)
//%lssis(i,j,s1,s2) calcule l'insertion d'un sous systeme lineaire
// decrit par une representation d'etat  dans un transfert statique
//Cette macro correspond a l'operation  s2(i,j)=s1
//!
// origine s. steer inria 1992
//
[a1,b1,c1,d1,x1,dom1]=s1(2:7)
d2=s2;
[n1,n1]=size(a1);

b2(1:n1,j)=b1
c2(i,1:n1)=c1
d2(i,j)=d1;
s=list('lss',a1,b2,c2,d2,x1,dom1)
//end


