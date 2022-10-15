clear;lines(0);
diag([1,2])

A=[1,2;3,4];
diag(A)  // main diagonal
diag(A,1) 

diag(sparse(1:10))  // sparse diagonal matrix

// form a tridiagonal matrix of size 2*m+1
m=5;diag(-m:m) +  diag(ones(2*m,1),1) +diag(ones(2*m,1),-1)
