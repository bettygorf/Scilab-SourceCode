function [sr]=%lssrp(s,p)
// sr=%lssrp(s,p) <=> sr=s/p
// s : syslin list
// p : polynomial matrix
//!
sr=s/tlist(['lss','A','B','C','D','X0','dt'],[],[],[],p,[],[])

