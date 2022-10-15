function [X,dim,dima]=basemod(A,B,tol)
//[X,dim,dima]=basemod(A,B,tol) computes a relative basis of B w.r.t. A .
// B do not contain necessarily A.
// X = basis such that first dima columns of X span range
// of A and first dima+dim columns span range(A+B)
// See also spanplus.
//!
//F.D.
[lh,rhs]=argn(0);
[na,ma]=size(a);[nb,mb]=size(b);
if rhs = 2 then tol=sqrt(%eps);end
[xp,dima]=rowcomp(a);x=xp';
up=1:dima;low=dima+1:na;
//test trivial cases :
//if dima=na then
//a is zero
if dima=0 then dim=0;return;end
b=xp*b;   //update
[v1,k2]=colcomp(b(up,:));
b1=b*v1;   //update
bup=b1(up,:);blow=b1(low,:);
if norm(bup,1) < tol*norm(blow,1)*mb*nb then k2=0;end
k1=mb-k2;
if k1=0 then dim=0;return;end
b2=b1(:,1:k1)
if norm(b2,1) < tol*norm(b,1)*nb*mb then dim=0,return,end
[x2p,dim]=rowcomp(b2(low,:))
x(:,low)=x(:,low)*x2p'



