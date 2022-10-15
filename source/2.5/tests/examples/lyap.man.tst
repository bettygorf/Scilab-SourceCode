clear;lines(0);
A=rand(4,4);C=rand(A);C=C+C';
X=lyap(A,C,'c');
A'*X + X*A -C
X=lyap(A,C,'d');
A'*X*A - X -C
