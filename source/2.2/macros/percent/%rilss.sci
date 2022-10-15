function s2=%rilss(i,j,s1,s2)
//%rilss(i,j,s1,s2) calcule l'insertion d'un sous systeme lineaire
// decrit par une fonction de transfertdans un systeme decrit par 
// une representation d'etat  
//Cette macro correspond a l'operation  s2(i,j)=s1
//!
// origine s. steer inria 1992
//
if type(i)==10|type(j)==10 then 
  error(21)
end
[s1 s2]=sysconv(s1,s2)
s2(i,j)=s1



