clear;lines(0);
  x=-5:5;y=x;
  deff('[z]=f(x,y)',['z= x.*y']);
  z=eval3d(f,x,y);
  plot3d(x,y,z);
// 
  deff('[z]=f(x,y)',['z= x*y']);
  z=feval(x,y,f);
  plot3d(x,y,z);
