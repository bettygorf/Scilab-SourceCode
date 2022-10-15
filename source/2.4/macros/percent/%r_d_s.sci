function r=%r_d_s(r,m)
// r=r./m
//!
// Copyright INRIA
if size(m,'*')==0 then r=[],return,end
r(3)=r(3).*m
r(2)=r(2).*ones(m)



