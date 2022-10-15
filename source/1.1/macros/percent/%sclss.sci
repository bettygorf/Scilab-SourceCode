function [s]=%sclss(d1,s2)
//  s=[d1,s2] d1 gain, s2 state-space
//!
// origin s. steer inria 1987
//
[a2,b2,c2,d2,x2,dom2]=s2(2:7)
[n2,m2]=size(b2);[p1,m1]=size(d1)
s=list('lss',a2,[0*ones(n2,m1),b2],c2,[d1,d2],x2,dom2)



