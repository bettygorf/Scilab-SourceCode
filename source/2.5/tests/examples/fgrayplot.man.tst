clear;lines(0);
t=-1:0.1:1;
deff("[z]=surf(x,y)","z=x**2+y**2")
fgrayplot(t,t,surf,"111",[-2,-2,2,2])
