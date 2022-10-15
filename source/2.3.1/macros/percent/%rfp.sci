function [f]=%rfp(f,p)
// f=%rfp(f,p) <=>f=[f;p]
//!
f(3)=[f(3);ones(p)]
f(2)=[f(2);p]


