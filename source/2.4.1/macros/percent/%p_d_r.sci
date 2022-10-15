function r=%p_d_r(p,r)
// r=%p_d_r(p,r) <=> r= p./r   polynomial./rational
// Copyright INRIA
[n,d]=r(2:3)
r(2)=d.*p;r(3)=n.*ones(p);



