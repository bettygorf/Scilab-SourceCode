function f=%p_f_r(m,f)
// %p_f_r(m,f) <=> f = [m;f]   [polynomial;rational]
//!
// Copyright INRIA
[n1,d1]=f(2:3),
[p,q]=size(m),
f=tlist(['r','num','den','dt'],[m;n1],[ones(p,q);d1],f(4)),



