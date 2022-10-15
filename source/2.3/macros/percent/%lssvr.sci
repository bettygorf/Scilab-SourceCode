function s=%lssvr(s1,s2)
//s=%lssvr(s1,s2) <=> s=s1/.s2 :feedback operation
//!
// origine s. steer inria 1988
[s1,s2]=sysconv(s1,s2);s=s1/.s2;


