function [x,dim]=im_inv(a,b,tol)
//[X,dim]=im_inv(A,B [,tol]) computes (A^-1)(B) i.e vectors whose
// image through A are in range(B).
// The dim first columns de X span (A^-1) (B)
// tol is a threshold to test if a  subspace is included in an other
// default value tol = 100*%eps;
// F.D.
//!
[lhs,rhs]=argn(0);
[na,ma]=size(a);[nb,mb]=size(b);
if rhs=2 then tol=100*%eps*ma*na*nb*mb,end;
if na<>nb then error ('uncompatible dimensions!'),return,end
// basis for im(b)
[xp,rb]=rowcomp(b);u=xp'
//Trivial cases
if rb >= na then x=eye(ma,ma);,dim=ma,return;end;
if rb =0 then [x,k1]=colcomp(a),dim=ma-k1,return,end
//
up=1:rb;low=rb+1:na;
a=xp*a;   //update 
//vectors with image in B
[x,r1]=colcomp(a(low,:))
a1=a*x;    //update
aup=a1(up,:);
alow=a1(low,:);    //alow(:,1:ma-r1)=0 by construction
if norm(alow,1) <= tol*norm(aup,1) then dim=ma,return,end
dim=ma-r1;



