clear;lines(0);
A=rand(5,3)*rand(3,4);     // A is 5 x 4, rank=3
B=[A(:,2),rand(5,1)]*rand(2,2);
[X,dim]=spaninter(A,B);
X1=X(:,1:dim);    //The intersection
svd(A),svd([X1,A])   // X1 in span(A)
svd(B),svd([B,X1])   // X1 in span(B)
