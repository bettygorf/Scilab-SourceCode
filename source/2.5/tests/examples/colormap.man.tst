clear;lines(0);
m=228;
n= fix(3/8*m);
r=[(1:n)'/n; ones(m-n,1)];
g=[zeros(n,1); (1:n)'/n; ones(m-2*n,1)];
b=[zeros(2*n,1); (1:m-2*n)'/(m-2*n)];
h=[r g b];
xset("colormap",h)
plot3d1()
xset("default")
