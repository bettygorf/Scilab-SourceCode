clear;lines(0);
x=sin(2*%pi*(0:5)/5);
y=cos(2*%pi*(0:5)/5);
plot2d(0,0,-1,"010"," ",[-2,-2,2,2])
xset("dashes",5)
xpoly(x,y,"lines",1)
xset("default")
