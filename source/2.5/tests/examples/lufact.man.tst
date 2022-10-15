clear;lines(0);
a=rand(5,5);b=rand(5,1);A=sparse(a);
[h,rk]=lufact(A);
x=lusolve(h,b);a*x-b
ludel(h)
