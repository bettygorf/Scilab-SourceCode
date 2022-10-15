// -----------------MAIN  CONTROL SCILAB PROGRAM--------------------
path=SCI+'/demos/bike'
exec(path+'/init.control.sci');
getf(path+'/fort2.bas','c');
exec(path+'/data.sci');
exec(path+'/datopt.sci');

// datopt.bas should provide:
// paramopt, 
// boundsmin and boundsmax: bounds on  control 
// u0: initial guess for control (size ncontr by nn-1)

// Internal variables
nnn=n+nf+ng;
indq=1:n;indqd=(n+1):2*n;   //(Indexes of q and qd in x)
xdeltat=(tmax-tmin)/(nnx-1);
deltat=(tmax-tmin)/(nn-1);
instants=tmin:deltat:tmax;
xinstants=tmin:xdeltat:tmax;

// Finding consistent initial conditions
[jstar,x_init]=optim(norm_cstrs,[q0;qd0]);
if jstar > 1.d-5 then 
write(%io(2),'inconsistent initial conditions');return;
end

// Finding open loop optimal control
x_initc=[x_init;0];
umin=diag(boundsmin)*ones(ncontr,nn-1);
umax=diag(boundsmax)*ones(ncontr,nn-1);
[f,uu,g]=optim(sim,'b',umin,umax,u0,0.01);

