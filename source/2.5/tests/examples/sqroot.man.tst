clear;lines(0);
X=rand(5,2)*rand(2,5);X=X*X';
W=sqroot(X)
norm(W*W'-X,1)
//
X=rand(5,2)+%i*rand(5,2);X=X*X';
W=sqroot(X)
norm(W*W'-X,1)
