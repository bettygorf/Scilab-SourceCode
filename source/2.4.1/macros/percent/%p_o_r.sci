function [r]=%p_o_r(l1,l2)
//r=%p_o_r(l1,l2) <=> r=(l1==l2) l1 polynomial  l2 rational
//!
// Copyright INRIA
r=degree(l2(3))==0
if r then r=l2(2)./coeff(l2(3))==l1,end


