//<f>=%pls(p,m)
// %pls(p,m) calcule la division a gauche de la matrice de scalaires m
//par la matrice de polynome ou le polynome p. Cette macro correspond
//a l'operation p\m.
//!
[l,c]=size(p)
if l*c <> 1 then f=invr(p)*m,return,end
[l,c]=size(m)
f=tlist('r',m,p*ones(l,c),[])
//end


