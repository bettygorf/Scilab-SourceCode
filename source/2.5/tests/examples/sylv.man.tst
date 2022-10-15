clear;lines(0);
A=rand(4,4);C=rand(4,3);B=rand(3,3);
X = sylv(A,B,C,'c');
norm(A*X+X*B-C)
X=sylv(A,B,C,'d') 
norm(A*X*B-X-C)
