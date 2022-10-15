function [s]=%lssap(s1,d2)
//s=%lssap(s1,d2)  iff
// s=s1+d2
//!
// origine s. steer inria 1992
//
[a1,b1,c1,d1,x1,dom1]=s1(2:7)
s=tlist('lss',a1,b1,c1,d1+d2,x1,dom1)



