function [sr]=%pllss(p,s)
//sr=%pllss(p,s) <=> sr=p\s
// p polynomial mat.
// s state-space syslin list
//!
//origine S Steer INRIA 1992
sr=tlist(['lss','A','B','C','D','X0','dt'],[],[],[],p,[],[])\s


