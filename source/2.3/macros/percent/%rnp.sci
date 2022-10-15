function [r]=%rnp(l1,l2)
//%rnp(l1,l2) <=> l1<>l2  
r=degree(l1(3))==0
if r then r=l1(2)./coeff(l1(3))==l2,end
r=~r



