function [sr]=%pvlss(p,s)
//  feedback sr=(eye+p*s)\p
//s=%pvlss(p,s) <=> sr=p/.s
// p : polynomial matrix
// s : state-space syslin list
//!
sr=tlist(['lss','A','B','C','D','X0','dt'],[],[],[],p,[],[])/.s

