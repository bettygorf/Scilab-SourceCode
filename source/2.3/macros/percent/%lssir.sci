function [s2]=%lssir(i,j,s1,s2)
//s2=%lssir(i,j,s1,s2) <=>  s2(i,j)=s1
//!
// origin s. steer inria 1992
[s1 s2]=sysconv(s1,s2)
s2(i,j)=s1



