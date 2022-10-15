function [r]=%rns(l1,l2)
//%rns(l1,l2) <=> l1<>l2     rational<>constant
r=degree(l1(2))==0&degree(l1(3))==0
if r then r=coeff(l1(2))./coeff(l1(3))==l2,end
r=~r



