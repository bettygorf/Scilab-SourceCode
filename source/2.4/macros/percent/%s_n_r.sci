function [r]=%s_n_r(l1,l2)
//%s_n_r(l1,l2) <=> l1<>l2 l1 constant  l2 rational
// et l2 une fraction rationnelle 
//!
// Copyright INRIA
r=degree(l2(2))==0&degree(l2(3))==0
if r then r=coeff(l2(2))./coeff(l2(3))==l1,end
r=~r



