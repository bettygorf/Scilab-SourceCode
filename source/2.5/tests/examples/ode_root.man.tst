clear;lines(0);
// Integration of the differential equation
// dy/dt=y , y(0)=1, and finds the minimum time t such that y(t)=2
deff('[ydot]=f(t,y)','ydot=y')
deff('[z]=g(t,y)','z=y-2')
y0=1;ng=1;
[y,rd]=ode('roots',y0,0,2,f,ng,g)
