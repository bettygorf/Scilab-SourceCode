clear;lines(0);
A=rand(5,2)*rand(2,4);
norm(A*pinv(A)*A-A,1)
