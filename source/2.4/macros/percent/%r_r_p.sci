function f=%r_r_p(f1,p2)
// 
//!
// Copyright INRIA
if prod(size(p2)) <>1 then f=f1*invr(p2),return,end
[n1,d1]=f1(2:3)
[n1,p2]=simp(n1,p2*d1)
f=tlist(['r','num','den','dt'],n1,p2,f1(4))



