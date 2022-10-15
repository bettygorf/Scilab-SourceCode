function [sp]=%spasp(sp1,sp2)
ij1=sp1(3);ij2=sp2(3);w1=sp1(2);w2=sp2(2);
ij=[ij1;ij2];w=[w1,w2];
sp=sparse(w,ij);
