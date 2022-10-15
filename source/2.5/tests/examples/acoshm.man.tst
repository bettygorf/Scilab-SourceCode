clear;lines(0);
A=[1,2;3,4];
coshm(acoshm(A))
A(1,1)=A(1,1)+%i;
coshm(acoshm(A))
