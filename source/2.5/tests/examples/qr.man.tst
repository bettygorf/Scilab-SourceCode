clear;lines(0);
A=rand(5,2)*rand(2,5);
[Q,R,rk,E] = qr(A,1.d-10);
norm(Q'*A-R)
svd([A,Q(:,1:rk)])    //span(A) =span(Q(:,1:rk))
