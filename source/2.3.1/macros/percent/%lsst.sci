function s=%lsst(s)
//s=%lsst(s)  <=> s=s'  in state-space
//!
[a,b,c,d,x,dom]=s(2:7)
s=tlist(['lss','A','B','C','D','X0','dt'],a',c',b',d',x,dom)



