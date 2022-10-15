function [s]=%lssrlss(s1,s2)
//
//!
[s1,s2]=sysconv(s1,s2)
s=s1*inv(s2)



