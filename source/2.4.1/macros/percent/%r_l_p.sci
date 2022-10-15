function f=%r_l_p(f,m)
// %r_l_p(f,p) <=> f\m
//!
// Copyright INRIA
if prod(size(f(2)))<>1 then f=invr(f)*m,return,end
[l,c]=size(m);
num=m*f(3);den=ones(l,c)*f(2);f(2)=num;f(3)=den;



