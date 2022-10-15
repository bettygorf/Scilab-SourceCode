function [x]=bike(speed,bankangle,direction,tmax)
//speed=5.5;bankangle=-5;direction=7;tmax=8;
//Simulation macro
//!
[q0,qd0]=qinit(speed,bankangle,direction);
n=23;indq=1:n;indqd=(n+1):2*n;
ncontr=2;
nf=16;ng=4;nnn=n+nf+ng;

tmin=0;
nn=400;
deltat=(tmax-tmin)/nn;
instants=tmin:deltat:tmax;

//               FINDING CONSISTENT INITIAL CONDITIONS
flags=ones(1,2*n);flags(5)=0;flags(18)=0;flags(n+1)=0;
[f,x_init]=optim(norm_cstrs,[q0;qd0]);
if f>1.d-5 then 
write(%io(2),'inconsistent initial conditions');return;
end
//                         SIMULATION
pause;
x=ode('adams',x_init,tmin,instants,simul);
//end
