clear;lines(0);
A=eye(2,2);B=[1;1];
x0=[-1;-2];
u=[1,2,3,4,5];
x=ltitr(A,B,u,x0)
x1=A*x0+B*u(1)
x2=A*x1+B*u(2)
x3=A*x2+B*u(3) //....
