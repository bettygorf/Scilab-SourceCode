function f=%r_q_s(f1,n2)
//  r.\m
//!
// Copyright INRIA
if size(n2,'*')==0 then f=[],return,end
f=tlist(f1(1),f1(3).*n2,f1(2).*ones(n2),f1(4))



