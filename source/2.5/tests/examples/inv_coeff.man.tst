clear;lines(0);
A=int(10*rand(2,6))
// Building a degree 1 polynomial matrix
P=inv_coeff(A,1)
norm(coeff(P)-A)
// Using default value for degree
P1=inv_coeff(A)
norm(coeff(P1)-A)
