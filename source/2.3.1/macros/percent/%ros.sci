function r=%ros(l1,l2)
//%ros(l1,l2) <=> l1==l2 with l1 rational
//and l2 constant
//!
r=degree(l1(2))==0&degree(l1(3))==0
if r then r=coeff(l1(2))./coeff(l1(3))==l2,end



