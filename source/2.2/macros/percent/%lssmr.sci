function [s]=%lssmr(s1,s2)
//s=%lssmr(s1,s2) <=> s= s2*s1
//!
// origine s. steer inria 1988
//
[s1,s2]=sysconv(s1,s2);s=s1*s2



