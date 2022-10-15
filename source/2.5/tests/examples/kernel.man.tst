clear;lines(0);
A=rand(3,1)*rand(1,3);
A*kernel(A)
A=sparse(A);
clean(A*kernel(A))
