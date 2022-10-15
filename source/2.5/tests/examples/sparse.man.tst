clear;lines(0);
sp=sparse([1,2;4,5;3,10],[1,2,3])
size(sp)
x=rand(2,2);abs(x)-full(abs(sparse(x)))
