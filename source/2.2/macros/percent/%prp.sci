//<f>=%prp(p1,p2)
// %prp(p1,p2) calcule p1*(p2**(-1)) ou p1 est une matrice de polynomes
//et p2 un polynome ou une matrice de polynomes
//!
[l,c]=size(p2)
if l*c <>1 then f=p1*invr(p2),return,end
[l,c]=size(p1)
[p1 p2]=simp(p1,p2*ones(l,c))
f=tlist('r',p1,p2,[])
//end


