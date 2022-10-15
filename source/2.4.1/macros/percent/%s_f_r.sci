function f=%s_f_r(m,f1)
// %s_f_r(M,r)=[M,r]
//!
// Copyright INRIA
[n1,d1]=f1(2:3)
[p,q]=size(m)
f=tlist(['r','num','den','dt'],[m;n1],[ones(p,q);d1],f1(4))



