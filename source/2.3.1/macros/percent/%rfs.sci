function [f]=%rfs(f,m)
// f=%rfs(r,m) <=> f= [r;m]   [rational;constant]
//!
[p,q]=size(m)
f(2)=[f(2);m]
f(3)=[f(3);ones(p,q)]


