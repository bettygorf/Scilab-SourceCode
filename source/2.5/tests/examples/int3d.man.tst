clear;lines(0);
X=[0;1;0;0];
Y=[0;0;1;0];
Z=[0;0;0;1];
deff('v=f(xyz,numfun)','v=exp(xyz''*xyz)')
[RESULT,ERROR]=int3d(X,Y,Z,'int3dex')
// computes the integrand exp(x*x+y*y+z*z) over the 
//tetrahedron (0.,0.,0.),(1.,0.,0.),(0.,1.,0.),(0.,0.,1.)
