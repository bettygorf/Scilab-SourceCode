function [s]=%lssvs(s1,d2)
//s=%lssvs(s1,d2)  <=> s=s1/.d2 
//!
// origin s. steer inria 1987
[a1,b1,c1,d1,x1,dom1]=s1(2:7)
e12=1/(eye+d2*d1)
e21=eye-d1*e12*d2;e12=b1*e12
a=a1-e12*d2*c1
s=tlist('lss',a1-e12*d2*c1,e12,e21*c1,e21*d1,x1,dom1)



