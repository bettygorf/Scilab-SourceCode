clear;lines(0);
x=poly(0,'x');
v=[x*(x+1),x^2*(x+1),(x-2)*(x+1),(3*x^2+2)*(x+1)];
[pg,U]=hrmt(v);U=clean(U)
det(U)
