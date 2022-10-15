clear;lines(0);
A=[rand(2,5);[zeros(3,4),rand(3,1)]];B=[[1,1;1,1];zeros(3,2)];
W=rand(5,5);A=W*A;B=W*B;
[X,dim]=im_inv(A,B)
svd([A*X(:,1:dim),B])   //vectors A*X(:,1:dim) belong to range(B)
[X,dim,Y]=im_inv(A,B);[Y*A*X,Y*B]
