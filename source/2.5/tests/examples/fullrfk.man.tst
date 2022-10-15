clear;lines(0);
A=rand(5,2)*rand(2,5);[Bk,Ck]=fullrfk(A,3);
norm(Bk*Ck-A^3,1)
