//[r]=%lssnlss(s1,s2)
//%lssnlss(s1,s2) effectue le test d'inegalite de deux systemes d'etat
//correspond a l'operation s1<>s2
//!
for k=2:7,r=or(s1(k)<>s2(k));if r then return,end,end
//end


