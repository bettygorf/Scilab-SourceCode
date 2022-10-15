function [u]=givens(x,y)
//Syntax : u=givens(xy)
//         u=givens(x,y)
//
// xy = [x;y], u=givens(xy)
// returns a 2*2 matrix u such that u*xy=[r;0].
// givens(x,y)=givens([x;y])
//
//!
[lhs,rhs]=argn(0);if rhs=1 then y=x(2),x=x(1);end
if abs(y)=0 then  u=eye(2,2),return,end
if abs(x)=0 then  u=[0 1;1 0],return,end
//
nrm = norm([x y]);
alpha = x/abs(x);
c = abs(x)/nrm;
s = alpha*y'/nrm;
//
u=[c s;-conj(s) c]



