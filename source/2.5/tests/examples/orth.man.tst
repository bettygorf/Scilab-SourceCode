clear;lines(0);
A=rand(5,3)*rand(3,4);
[X,dim]=rowcomp(A);X=X';
svd([orth(A),X(:,1:dim)])
