function [x]=iihs(II,h,q,qd,u,param,alfa,beta,gama)
//!
A=list('sparse',II(q,qd,u,param,alfa,beta,gama),IIww,43,5000)
x=lusolve(h(q,qd,u,param,alfa,beta,gama),A)

