function [sr]=%lssvp(s,p)
// feedback sr=(eye+s*p)\s
//s=%lssvp(s,p) <=> sr=s/.p
// p : polynomial matrix
// s : state-space syslin list
//!
//origine S Steer INRIA 1992
sr=s/.tlist(['lss','A','B','C','D','X0','dt'],[],[],[],p,[],[])

