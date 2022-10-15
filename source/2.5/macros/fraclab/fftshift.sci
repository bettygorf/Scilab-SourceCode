function y = fftshift(x) 

// Copyright INRIA
[r,c] = size(x) ;
c1 = 1.:ceil(c/2.) ; c2 =ceil(c/2.)+1.:c ;
r1 = 1.:ceil(r/2.) ; r2 =ceil(r/2.)+1.:r ;
y = [x(r2,c2) x(r2,c1) ; x(r1,c2)  x(r1,c1)] ;
