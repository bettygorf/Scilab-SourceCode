clear;lines(0);
x=[0 1;2 4]
w=sqrtm(x); 
norm(w*w-x)
x(1,2)=%i;
w=sqrtm(x);norm(w*w-x,1)
