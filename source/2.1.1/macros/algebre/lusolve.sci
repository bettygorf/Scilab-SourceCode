function res=lusolve(fact,b)
[lhs,rhs]=argn(0);
if rhs<>2 then error('bad call to lusolve: needs 2 inputs'), end
if type(fact) <> 15 then error('lusolve: first argument must be a list'), end
res=lusolve1(fact(3),b)
