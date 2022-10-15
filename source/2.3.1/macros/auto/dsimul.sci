function [y]=dsimul(sld,u)
[a,b,c,d,x0]=sld(2:6);
y=c*ltitr(a,b,u,x0)+d*u;



