function [s]=%lssllss(s1,s2)
[s1,s2]=sysconv(s1,s2)
s=inv(s1)*s2
