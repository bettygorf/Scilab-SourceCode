clear;lines(0);
t=[0:0.3:2*%pi]'; z=sin(t)*cos(t');
[xx,yy,zz]=genfac3d(t,t,z);
plot3d(xx,yy,zz)
