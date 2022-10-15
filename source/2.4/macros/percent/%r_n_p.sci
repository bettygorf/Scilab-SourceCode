function [r]=%r_n_p(l1,l2)
//%r_n_p(l1,l2) <=> l1<>l2  
// Copyright INRIA
r=degree(l1(3))==0
if r then r=l1(2)./coeff(l1(3))==l2,end
r=~r



