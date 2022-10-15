clear;lines(0);
A=rand(3,3);B=rand(3,2);
F=ppol(A,B,[-1,-2,-3]);
spec(A-B*F)
