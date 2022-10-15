function f=%prp(p1,p2)
// f=%prp(p1,p2) <=> f= p1*(p2^(-1)) 
//p1 polynomial matrix
//p2 polynomial matrix
//!
[l,c]=size(p2)
if l*c <>1 then f=p1*invr(p2),return,end
[l,c]=size(p1)
[p1 p2]=simp(p1,p2*ones(l,c))
f=tlist(['r','num','den','dt'],p1,p2,[])



