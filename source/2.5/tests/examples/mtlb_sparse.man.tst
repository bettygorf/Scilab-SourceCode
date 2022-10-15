clear;lines(0);
X=sparse(rand(2,2)); Y=mtlb_sparse(X);
Y, full(Y), [ij,v,mn]=spget(Y)
