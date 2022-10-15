function [f]=%r_f_r(s1,s2)
//f=[s1;s2] 
//!
// Copyright INRIA
[s1,s2]=sysconv(s1,s2)
f=tlist(['r','num','den','dt'],[s1(2);s2(2)],[s1(3);s2(3)],s1(4))



