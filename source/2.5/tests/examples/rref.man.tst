clear;lines(0);
A=[1 2;3 4;5 6];
X=rref([A,eye(3,3)]);
R=X(:,1:2)
L=X(:,3:5);L*A
