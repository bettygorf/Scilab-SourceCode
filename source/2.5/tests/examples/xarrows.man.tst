clear;lines(0);
x=2*%pi*(0:9)/8;
x1=[sin(x);9*sin(x)];
y1=[cos(x);9*cos(x)];
plot2d([-10,10],[-10,10],[-1,-1],"022")
xset("clipgrf")
xarrows(x1,y1,1,1:10)
xset("clipoff")
