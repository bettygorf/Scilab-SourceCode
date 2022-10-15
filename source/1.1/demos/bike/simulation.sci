//[x]=simulation(tmin,tmax)
//Simulation macro: 

exec('data.sci');  
// data.sci should provide the param vector and initialize:
// n,nf,ng
// nn and nnx: # of discretization points of u and of x.
// q0 and qd0: guessed initial position and velocity
// flags: binary vector indicating which components
//        of q0 and qd0 are fixed.
// scilab macro ``control'' should be provided as well evaluating  u
// as a function of time, position and velocity; u = control(t,[q;qd])


// Internal variables
deltat=(tmax-tmin)/nn;
instants=tmin:deltat:tmax;
nnn=n+nf+ng;
indq=1:n;indqd=(n+1):2*n;

//               FINDING CONSISTENT INITIAL CONDITIONS

[err,x_init]=optim(norm_cstrs,[q0;qd0]);
if err>1.d-5 then 
             write(%io(2),'inconsistent initial conditions');return;
end
//                         SIMULATION
x=ode('adams',x_init,tmin,instants,simul);
//end
