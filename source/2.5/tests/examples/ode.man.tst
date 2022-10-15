clear;lines(0);
// Simple one dimension ODE
// dy/dt=y^2-y sin(t)+cos(t), y(0)=0
deff('[ydot]=f(t,y)','ydot=y^2-y*sin(t)+cos(t)')
y0=0;t0=0;t=0:0.1:%pi;
y=ode(y0,t0,t,f)
plot(t,y)
// Simulation of dx/dt = A x(t) + B u(t) with u(t)=sin(omega*t),
// x0=[1;0] ; 
// solution x(t) desired at t=0.1, 0.2, 0.5 ,1.
// A and u function are passed to RHS function in a list. 
// B and omega are passed as global variables
deff('[xdot]=linear(t,x,A,u)','xdot=A*x+B*u(t)')
deff('[ut]=u(t)','ut=sin(omega*t)')
A=[1 1;0 2];B=[1;1];omega=5;
ode([1;0],0,[0.1,0.2,0.5,1],list(linear,A,u))
//
// Matrix notation
// Integration of the Riccati differential equation
// Xdot=A'*X + X*A - X'*B*X + C ,  X(0)=Identity
// Solution at t=[1,2] 
deff('[Xdot]=ric(t,X)','Xdot=A''*X+X*A-X''*B*X+C')   
A=[1,1;0,2]; B=[1,0;0,1]; C=[1,0;0,1];
X=ode(eye(A),0,t,ric)
//
// Computation of exp(A)
A=[1,1;0,2];
deff('[xdot]=f(t,x)','xdot=A*x');
ode(eye(A),0,1,f)
ode('adams',eye(A),0,1,f)
// with stiff matrix, Jacobian given
A=[10,0;0,-1];
deff('[J]=Jacobian(t,y)','J=A')
ode('stiff',[0;1],0,1,f,Jacobian)
