function [f]=%rcr(s1,s2)
//f=[s1,s2]
//!
[s1,s2]=sysconv(s1,s2)
f=list('r',[s1(2),s2(2)],[s1(3),s2(3)],s1(4))



