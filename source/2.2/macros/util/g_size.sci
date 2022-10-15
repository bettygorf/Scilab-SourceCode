function [m,n,nx]=g_size(x)
// only to be called by size function for dynamical systems 
//!
[lhs,rhs]=argn(0)
if x(1)=='r' then
 if lhs==1 then m=size(x(2));end
 if lhs==2 then [m,n]=size(x(2));end
 if lhs>2 then error('bad call to size function (not state-space!)');end
else
 [a,b,c,d]=x(2:5);[m,w]=size([c,d]),[w,n]=size([b;d]);
if lhs==1 then m=[m,n];end
if lhs==3 then [nx,nx]=size(a);end;
end
