function f=%r_c_s(f,m)
// f=%r_c_s(r,m) <=> f=[r, m]   [rational, constant]
//!
// Copyright INRIA
[p,q]=size(m)
f(2)=[f(2),m]
f(3)=[f(3),ones(p,q)]



