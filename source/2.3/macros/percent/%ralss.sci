function s=%ralss(s1,s2)
//s=%ralss(s1,s2) <=> s=s1+s2  rational + state-space
//!
// origine s. steer inria 1988
//
[s1,s2]=sysconv(s1,s2);s=s1+s2;



