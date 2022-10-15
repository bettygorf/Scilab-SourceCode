function [s]=%svlss(d1,s2)
//s=%svlss(d1,s2)  <=> s=d1/.s2
// origin s. steer inria 1987
[a2,b2,c2,d2,x2,dom2]=s2(2:7)
e12=1/(eye+d2*d1)
e21=eye-d1*e12*d2;b21=b2*e21
s=tlist('lss',a2-b21*d1*c2,b21*d1,-e21*d1*c2,e21*d1,...
        x2,dom2)



