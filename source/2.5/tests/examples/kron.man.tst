clear;lines(0);
A=[1,2;3,4];
kron(A,A)
A.*.A
sparse(A).*.sparse(A)
A(1,1)=%i;
kron(A,A)
