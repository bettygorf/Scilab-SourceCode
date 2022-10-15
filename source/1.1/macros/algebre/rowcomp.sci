function [w,rk]=rowcomp(A,flag,tol)
//Row compression of A <--> comput. of im(A)
//flag and tol are optional parameters
//flag='qr' or 'svd' (default 'svd')
//tol tolerance parameter (of order %eps as default value)
//the rk first (top) rows of w span the row range of a
//the rk first columns of w' span the image of a
//F.D. (1987)
//!
[ma,na]=size(A)
[lhs,rhs]=argn(0)
if a=[] then w=[];rk=0;return;end
if norm(a,1) < sqrt(%eps)/10 then rk=0,w=eye(ma,ma),return;end
if rhs =2 then tol=sqrt(%eps)*norm(a,1)*na*ma,end
if rhs=1 then flag='svd',tol=sqrt(%eps)*norm(a,1)*ma*na;end
select flag
case 'qr' then [q,r,rk]=qr(a,tol);w=q';
case 'svd' then [u,s,v,rk]=svd(a,tol);w=u' ;
end


