clear;lines(0);
x=poly(0,'x');
det([x,1+x;2-x,x^2])
w=ssrand(2,2,4);roots(det(systmat(w))),trzeros(w)   //zeros of linear system
A=rand(3,3);
det(A), prod(spec(A))
