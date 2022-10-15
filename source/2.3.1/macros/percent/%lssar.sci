function [s]=%lssar(s1,s2)
//s=%lssar(s1,s2)  <=> s= s1+s2
//!
[s1,s2]=sysconv(s1,s2);s=s1+s2;



