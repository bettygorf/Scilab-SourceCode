clear;lines(0);
nx=5;nu=1;ny=1;un=3;us=2;Sys=ssrand(ny,nu,nx,list('dt',us,us,un));
//nx=5 states, nu=1 input, ny=1 output, 
//un=3 unobservable states, us=2 of them unstable.
[Obs,U,m]=observer(Sys);  //Stable observer (default)
W=U';H=W(m+1:nx,:);[A,B,C,D]=abcd(Sys);  //H*U=[0,eye(no,no)];
Sys2=ss2tf(syslin('c',A,B,H))  //Transfer u-->z
Idu=eye(nu,nu);Sys3=ss2tf(H*U(:,m+1:$)*Obs*[Idu;Sys])  
//Transfer u-->[u;y=Sys*u]-->Obs-->xhat-->HUxhat=zhat  i.e. u-->output of Obs
//this transfer must equal Sys2, the u-->z transfer  (H2=eye).
