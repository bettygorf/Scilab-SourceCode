function [f]=%r_f_p(f,p)
// f=%r_f_p(f,p) <=>f=[f;p]
//!
// Copyright INRIA
f(3)=[f(3);ones(p)]
f(2)=[f(2);p]


