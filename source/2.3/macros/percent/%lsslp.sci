function [sr]=%lsslp(s,p)
//sr=%lsslp(s,p) <=> sr=s\p
// p polynomial matrix
// s syslin list
//!
//origine S Steer INRIA 1992
sr=s\tlist(['lss','A','B','C','D','X0','dt'],[],[],[],p,[],[])


