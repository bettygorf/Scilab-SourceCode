clear;lines(0);
X=[0,0;1,1;1,0];
Y=[0,0;0,1;1,1];
deff('z=f(x,y)','z=cos(x+y)')
[I,e]=int2d(X,Y,f)
// computes the integrand over the square [0 1]x[0 1]
