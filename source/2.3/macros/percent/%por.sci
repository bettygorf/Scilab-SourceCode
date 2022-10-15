function [r]=%por(l1,l2)
//r=%por(l1,l2) <=> r=(l1==l2) l1 polynomial  l2 rational
//!
r=degree(l2(3))==0
if r then r=l2(2)./coeff(l2(3))==l1,end


