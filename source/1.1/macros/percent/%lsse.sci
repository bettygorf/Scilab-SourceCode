//<f>=%lsse(i,j,f)
//<f>=%lsse(i,j,s)  extrait le sous systeme s1 qui correspond aux sorties
//(entrees) designees par le vecteur d'indice  i (j)  du systeme lineaire
//decrit par sa representation d'etat s,
//Cette macro correspond a l'operation s1=s(i,j)
//!
// origine s. steer inria 1988
//
[a,b,c,d,x0,dom]=f(2:7)
f=list('lss',a,b(:,j),c(i,:),d(i,j),x0,dom)
//end


