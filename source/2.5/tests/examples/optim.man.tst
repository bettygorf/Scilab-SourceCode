clear;lines(0);
xref=[1;2;3];x0=[1;-1;1]
deff('[f,g,ind]=cost(x,ind)','f=0.5*norm(x-xref)^2,g=x-xref');
[f,xopt]=optim(cost,x0)      //Simplest call
[f,xopt,gopt]=optim(cost,x0,'gc')  // By conjugate gradient
[f,xopt,gopt]=optim(cost,x0,'nd')  //Seen as non differentiable
[f,xopt,gopt]=optim(cost,'b',[-1;0;2],[0.5;1;4],x0) //  Bounds on x
[f,xopt,gopt]=optim(cost,'b',[-1;0;2],[0.5;1;4],x0,'gc') //  Bounds on x
[f,xopt,gopt]=optim(cost,'b',[-1;0;2],[0.5;1;4],x0,'gc','ar',3)
// Here, 3 calls to cost are allowed.
// Now calling the Fortran subroutine "genros" in SCIDIR/default/Ex-optim.f
// See also the link function for dynamically linking an objective function
[f,xopt,gopt]=optim('genros',[1;2;3])    //Rosenbrock's function
