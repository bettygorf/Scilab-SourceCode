clear;lines(0);
X1=rand(5,2);X2=rand(5,3);
P=proj(X1,X2);
norm(P^2-P,1)
trace(P)    // This is dim(X2)
[Q,M]=fullrf(P);
svd([Q,X2])   // span(Q) = span(X2)
