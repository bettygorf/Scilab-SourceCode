clear;lines(0);
A=[1,2,3];
norm(A,1)
norm(A,'inf')
A=[1,2;3,4]
max(svd(A))-norm(A)

A=sparse([1 0 0 33 -1])
norm(A)

