//[f,g,ind]=norm_cstrs(x,ind)
q=x(indq);qd=x(indqd);
ctr=constr(q,qd,param);
g=ctr'*gjx(q,qd,param)*diag(flags);
f=0.5*ctr'*ctr;
//end

//[xdot]=simul(t,x)
q=x(indq);
qd=x(indqd);
u=control(t,x);
qdd_lam=iihs(II,h,q,qd,u,param,alfa,beta,gamma);
xdot=[qd;qdd_lam(1:n)];
//end

//[u]=control(t,x)
// Controls 
//v=0;
//if t>.1 then v=1; end;
//if t>.3 then v=0; end;
//if t>.5 then v=0; end;
//if t>.7 then u=0; end;
//u=[v;0*v];
u=[0;0];
//end


//[delta]=steerangle(x)
delta=asin(sin(x(5,:)).*sin(x(18,:)-x(4,:))./sin(x(14,:)));
//end


//[qdd,lambda]=qddlam(instants,x)
qdd=[];lambda=[];
k=0;
for t=instants,k=k+1; 
u=control(t,x(:,k));
qdd_lam=iihs(II,h,x(indq,k),x(indqd,k),u,param,alfa,beta,gamma);
qdd=[qdd,qdd_lam(1:n)];lambda=[lambda,qdd_lam(n+1:nnn)];
end;
//end
