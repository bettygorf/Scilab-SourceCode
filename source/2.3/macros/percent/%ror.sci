function r=%ror(l1,l2)
//%ror(l1,l2) <=> l1==l2 with l1 and l2 rationals
//!
//r=l1(4)==l2(4)&l1(2)==l2(2)&(l1(3)==l2(3)|l1(2)==0)
if varn([l1(2),l1(3)])~=varn([l2(2),l2(3)]) then r=%f;return;end
r=(l1(4)==l2(4))&((l1-l2)==0)


