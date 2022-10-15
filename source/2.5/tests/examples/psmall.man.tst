clear;lines(0);
A=diag([1,2,3]);X=rand(A);A=inv(X)*A*X;
[Q,M]=psmall(A,2.5,'d');
spec(M*A*Q)
[Q1,M1]=fullrf(eye()-Q*M);
spec(M1*A*Q1)
