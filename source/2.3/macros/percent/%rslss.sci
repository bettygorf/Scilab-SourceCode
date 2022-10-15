function [s]=%rslss(s1,s2)
//s=%rslss(s1,s2) ou s=s1-s2
// s1 : transfer
// s2 : state-space
//!
[s1,s2]=sysconv(s1,s2)
s=s1-s2


