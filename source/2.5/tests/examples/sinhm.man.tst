clear;lines(0);
A=[1,2;2,3]
asinhm(sinhm(A))
A(1,1)=%i;sinhm(A)-(expm(A)-expm(-A))/2   //Complex case
