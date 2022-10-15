function [f]=%r_f_s(f,m)
// f=%r_f_s(r,m) <=> f= [r;m]   [rational;constant]
//!
// Copyright INRIA
[p,q]=size(m)
f(2)=[f(2);m]
f(3)=[f(3);ones(p,q)]


