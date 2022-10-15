function [totc,totc_u]=cost(uu)
// Computes the total cost totc and its gradient totc_u 
// associated with uu.
// Forward integration : x=[q;qd;integral(c)] evaluated at xinstants 
x=ode('adams',x_initc,tmin,xinstants,simulfor);
// Computation of the cost: final cost psi + integrated cost intc
intc=x(2*n+1,nnx);qfinal=x(indq,nnx);qdfinal=x(indqd,nnx);
totc=psi(qfinal,qdfinal)+intc;
// Initialization of the backward integration 
//        xxf=[p2final;p1final;mufinal;0]
xxf=fcond(qfinal,qdfinal);
// Backward integration : xx=[p2;p1;mu;integral(hamu)]
xx=ode('adams',xxf,tmax,tmax:-deltat:tmin,backsimul);
// Computation of the gradient
ih_u=xx(2*n+nf+ng+1:2*n+nf+ng+ncontr,nn:-1:1);
totc_u=ih_u(:,2:nn)-ih_u(:,1:nn-1);

 
function [xdot]=simulfor(t,x)
// Returns xdot = [qd,qdd,c] given t and x=[q,qd] 
q=x(indq);qd=x(indqd);
k=ent(t/deltat)+1;u=uu(:,k);
qdd_lam=iihs(II,h,q,qd,u,param,alfa,beta,gamma);
qdd=qdd_lam(1:n);
xdot=[qd;qdd;c(q,qd,u)];


function [xxdot]=backsimul(t,xx)
// Returns [p2dot,p1dot,mudot,hamu] 
p2=xx(1:n);p1=xx(n+1:2*n);
k=ent(t/deltat)+1;u=uu(:,k);
// Interpolation
kx=ent(t/xdeltat)+1;
ci=(t-(kx-1)*xdeltat)/xdeltat;
q =x(indq,kx)*ci+x(indq,kx+1)*(1-ci);
qd=x(indqd,kx)*ci+x(indqd,kx+1)*(1-ci);
// Solving the sparse linear system II qdd_lam = h for finding lambda
qdd_lam=iihs(II,h,q,qd,u,param,alfa,beta,gamma);
lambda=qdd_lam(n+1:n+nf+ng);
//Solving the sparse linear system Emat (p2p1mudot) = Fvec
p2p1mudot=efs(Emat,Fvec,q,qd,u,lambda,p1,p2,param,paramopt);
xxdot=[p2p1mudot;hamu(q,qd,u,p1,p2)];


function [p2p1muh_uf]=fcond(qfinal,qdfinal)
// Initialization of the backward integration of the adjoint system
// Solving the sparse linear system Emat p2p1mu = vecfin
p2p1mu=efs(Emat,vecfin,qfinal,qdfinal,zeros(ncontr,1),zeros(nf+ng,1),...
           0*qf,0*qf,param,paramopt);
p2p1muh_uf=[p2p1mu;zeros(ncontr,1)];

function [z]=zeros(n,m)
z=0*ones(n,m)
