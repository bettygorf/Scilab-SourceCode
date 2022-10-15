clear;lines(0);
W=rand(5,5)+%i*rand(5,5);
X=W*W';
R=chol(X);
norm(R'*R-X)
