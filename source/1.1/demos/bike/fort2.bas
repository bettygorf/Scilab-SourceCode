//[xxdot]=backsimul(t,xx)
t=mini(maxi(t,tmin),tmax-3*%eps);
k=ent(t/deltat)+1;
u=uu(:,k);
p2=xx(1:n);
p1=xx(n+1:2*n);
kx=ent(t/xdeltat)+1;
ci=(t-(kx-1)*xdeltat)/xdeltat;
q =x(1:n,kx)*ci+x(1:n,kx+1)*(1-ci);
qd=x(n+1:2*n,kx)*ci+x(n+1:2*n,kx+1)*(1-ci);
qdd_lam=iihs(II,h,q,qd,u,param,alfa,beta,gamma);
lambda=qdd_lam(n+1:nnn);
xxdotb=efs(Emat,Fvec,q,qd,u,lambda,p1,p2,param,paramopt);
fifi=hamu(q,qd,u,p1,p2);
xxdot=[xxdotb;fifi];
//end


//[f,g,ind]=norm_cstrs(x,ind)
q=x(indq);
qd=x(indqd);
ctr=constr(q,qd,param);
g=ctr'*gjx(q,qd,param)*diag(flags);
f=0.5*ctr'*ctr;
//end

//[pdpmuh_uf]=fcond(qqdf)
qf=qqdf(1:n);
qdf=qqdf(n+1:2*n);
ppdmuf=efs(Emat,vecfin,qf,qdf,zeros(ncontr,1),zeros(nf+ng,1),...
           0*qf,0*qf,param,paramopt);
pdpmuh_uf=[ppdmuf;zeros(ncontr,1)];
//end


//[f,g,ind]=sim(uu,ind)
x=ode('adams',x_initc,tmin,xinstants,simulfor);
[n1,n2]=size(x);
if n2 < nnx | mini(x(9,:)-x(3,:)) < 0.1*r1 then
              ind=-1;f=0;g=ones(uu);
              write(%io(2),'crash!!!!!!');
            else
              f=psi(x(1:n,nnx),x(n+1:2*n,nnx))+x(2*n+1,nnx);
              print(6,f);
              //pplot(uu);
              xxf=fcond(x(1:2*n,nnx));
              xx=ode('adams',xxf,tmax,tmax:-deltat:tmin,1.d-4,1.d-6,backsimul);
              ih_u=xx(2*n+nf+ng+1:2*n+nf+ng+ncontr,nn:-1:1);
              g=ih_u(:,2:nn)-ih_u(:,1:nn-1);
              show(x,1,1);
end;
//end


//[xdot]=simulfor(t,x)
t=mini(maxi(t,tmin),tmax-3*%eps);
k=ent(t/deltat)+1;
q=x(indq);
qd=x(indqd);
u=uu(:,k);
qdd_lam=iihs(II,h,q,qd,u,param,alfa,beta,gamma);
xdot=[qd;qdd_lam(1:n);c(q,qd,u)];
//end


//[]=pplot(x)
//multiple plot of a matrix
//Unknown Authors 
//!
[n,m]=size(x);
splitview(n,1)
for k=1:n,plot(x(k,:));end
splitview();
//end

//[z]=zeros(m,n)
z=0*ones(m,n)
//end
