//[]=chaintst(f_l,b1,odem,xdim,npts)
//[]=chaintst([f_l,b1,odem,xdim,npts])
// Integration of the chain model
// a Three-species food chain model 
//!
[lhs,rhs]=argn(0);
if rhs <=0, f_l=chain;end
if rhs <=1, b1=3.0;end
if rhs <=2, odem='default';end;
if rhs <=4, npts=[1000,0.1],end;
if rhs <=3 then 
   xdim=[0,1,0,1,5,11];
end;
x_message(["Integration of a Three-species food chain model "]);
portr3d(f_l,odem,xdim,npts);
//end

//[xdot]=chain(t,x)
ff1= f1(x(1))
ff2= f2(x(2))
x1= x(1)*(1-x(1)) - ff1*x(2)
x2= ff1*x(2) -  ff2*x(3) - 0.4*x(2)
x3= ff2*x(3) - 0.01*x(3)
xdot=[x1;x2;x3];
//end

//[z1]=f1(u)
z1=5*u/(1+b1*u)
//end

//[z2]=f2(u)
z2=0.1*u/(1+2*u)
//end
