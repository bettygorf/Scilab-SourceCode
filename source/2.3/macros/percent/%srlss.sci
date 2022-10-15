function [sr]=%srlss(p,s)
// sr=%srlss(p,s) ou sr=p/s
// s : syslin list
// p : constant matrix
//!
//origine S Steer INRIA 1992
sr=tlist(['lss','A','B','C','D','X0','dt'],[],[],[],p,[],[])/s
