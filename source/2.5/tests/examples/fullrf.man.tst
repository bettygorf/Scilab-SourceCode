clear;lines(0);
A=rand(5,2)*rand(2,5);
[Q,M]=fullrf(A);
norm(Q*M-A,1)
[X,d]=rowcomp(A);Y=X';
svd([A,Y(:,1:d),Q])        //span(Q) = span(A) = span(Y(:,1:2))
