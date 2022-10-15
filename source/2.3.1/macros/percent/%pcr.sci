function f=%pcr(m,f)
// f= %pcr(m,f) <=> r= [m,f]  m:polynomial mat. r: rational mat.
//!
[n1,d1]=f(2:3),
[p,q]=size(m),
f=tlist(['r','num','den','dt'],[m n1],[ones(p,q),d1],f(4)),



