clear;lines(0);
// simple plot using z=f(x,y)
t=[0:0.3:2*%pi]'; z=sin(t)*cos(t');
plot3d1(t,t,z)
// same plot using facets computed by genfac3d
[xx,yy,zz]=genfac3d(t,t,z);
xbasc()
plot3d1(xx,yy,zz)
// multiple plots
xbasc()
plot3d1([xx xx],[yy yy],[zz 4+zz])
// simple plot with viewpoint and captions
xbasc()
plot3d1(1:10,1:20,10*rand(10,20),35,45,"X@Y@Z",[2,2,3])
// same plot without grid
xbasc()
plot3d1(1:10,1:20,10*rand(10,20),35,45,"X@Y@Z",[-2,2,3])
// plot of a sphere using facets computed by eval3dp
deff("[x,y,z]=sph(alp,tet)",["x=r*cos(alp).*cos(tet)+orig(1)*ones(tet)";..
  "y=r*cos(alp).*sin(tet)+orig(2)*ones(tet)";..
  "z=r*sin(alp)+orig(3)*ones(tet)"]);
r=1; orig=[0 0 0];
[xx,yy,zz]=eval3dp(sph,linspace(-%pi/2,%pi/2,40),linspace(0,%pi*2,20));
xbasc()
plot3d1(xx,yy,zz)
