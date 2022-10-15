function fact=lufact(spars)
[lhs,rhs]=argn(0), if rhs<>1 then error('bad argument number'), end
if type(spars)<>15 then error('the argument must be a list'), end
m=spars(4);n=spars(5);
if m<>n then error("lufact: waiting for a square matrix!");end
sp2=spars(2);
fmat=lufact1(matrix(sp2,prod(size(sp2)),1),spars(3),spars(5))
fact=list('factored',n,fmat)
