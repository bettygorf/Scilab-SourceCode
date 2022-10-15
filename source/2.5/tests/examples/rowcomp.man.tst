clear;lines(0);
A=rand(5,2)*rand(2,4);   // 4 col. vectors, 2 independent.
[X,dim]=rowcomp(A);Xp=X';
svd([Xp(:,1:dim),A])     //span(A) = span(Xp(:,1:dim)
x=A*rand(4,1);      //x belongs to span(A)
y=X*x  
norm(y(dim+1:$))/norm(y(1:dim))    // small
