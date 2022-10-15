clear;lines(0);
A=rand(5,4)*rand(4,5);
[U,s,V]=sva(A,2);
B=U*s*V';
svd(A)
svd(B)
clean(svd(A-B))
