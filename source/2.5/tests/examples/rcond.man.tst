clear;lines(0);
A=diag([1:10]);
rcond(A)
A(1,1)=0.000001;
rcond(A)
