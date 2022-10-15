function [dim,x]=unobs(A,C,tol)
// n first columns of x span the unobservable
// subspace of (A,C):
//          dim  
//          [*,*]
// X'*A*X = [0,*]
// 
//    C*X = [0,*]
[p,p]=size(a);
[n,w]=contr(A',C');
x=[w(:,n+1:p),w(:,1:n)];
dim=p-n;



