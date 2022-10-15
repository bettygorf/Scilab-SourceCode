clear;lines(0);
deff("[z]=surf(x,y)","z=sin(x)*cos(y)")
t=%pi*(-10:10)/10;
// 3D plot of the surface
fplot3d(t,t,surf,35,45,"X@Y@Z")
// now (t,t,sin(t).*cos(t)) is a curve on the surface
// which can be drawn using geom3d and xpoly
[x,y]=geom3d(t,t,sin(t).*cos(t));
xpoly(x,y,"lines")
// adding a comment 
[x,y]=geom3d([0,0],[0,0],[5,0]);
xsegs(x,y)
xstring(x(1),y(1),"point (0,0,0)")
