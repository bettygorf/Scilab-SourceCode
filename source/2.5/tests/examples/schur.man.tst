clear;lines(0);
A=diag([-0.9,-2,2,0.9]);X=rand(A);A=inv(X)*A*X;
[U,d]=schur(A,'c');
A1=U'*A*U;
spec(A1(1:d,1:d))      //stable cont. eigenvalues
[U,d]=schur(A,'c');
A1=U'*A*U;
spec(A1(1:d,1:d))      //stable disc. eigenvalues
