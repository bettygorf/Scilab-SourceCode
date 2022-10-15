function [r]=%sor(l1,l2)
//%sor(l1,l2) constant==rational
//!
r=degree(l2(2))==0&degree(l2(3))==0
if r then r=coeff(l2(2))./coeff(l2(3))==l1,end



