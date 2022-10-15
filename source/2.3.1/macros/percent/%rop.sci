function r=%rop(l1,l2)
//%rop(l1,l2) <=> l1==l2  with l1 rational and 
// l2 polynomial
//!
r=degree(l1(3))==0
if r then r=l1(2)./coeff(l1(3))==l2,end



