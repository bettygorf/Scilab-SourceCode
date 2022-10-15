clear;lines(0);
A=rand(5,2)*rand(2,5);
[X,r]=colcomp(A);
norm(A*X(:,1:$-r),1)
