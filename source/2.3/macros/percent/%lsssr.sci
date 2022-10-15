function [s]=%lsssr(s1,s2)
//s=%lsssr(s1,s2) <=> s=s1-s2
// s1 : state-space
// s2 : transfer matrix
//!
[s1,s2]=sysconv(s1,s2)
s=s1-s2



