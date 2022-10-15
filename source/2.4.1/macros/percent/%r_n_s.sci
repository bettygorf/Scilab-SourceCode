function [r]=%r_n_s(l1,l2)
//%r_n_s(l1,l2) <=> l1<>l2     rational<>constant
// Copyright INRIA
r=degree(l1(2))==0&degree(l1(3))==0
if r then r=coeff(l1(2))./coeff(l1(3))==l2,end
r=~r



