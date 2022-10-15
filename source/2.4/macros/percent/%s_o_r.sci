function [r]=%s_o_r(l1,l2)
//%s_o_r(l1,l2) constant==rational
//!
// Copyright INRIA
r=degree(l2(2))==0&degree(l2(3))==0
if r then r=coeff(l2(2))./coeff(l2(3))==l1,end



