clear;lines(0);
A=[1/2^10,1/2^10;2^10,2^10];
[Ab,X]=balanc(A);
norm(A(1,:))/norm(A(2,:))
norm(Ab(1,:))/norm(Ab(2,:))
