function f=%scr(m,f1)
// %scr(M,r)=[M,r]
//!
[n1,d1]=f1(2:3)
[p,q]=size(m)
f=tlist(['r','num','den','dt'],[m n1],[ones(p,q),d1],f1(4))


