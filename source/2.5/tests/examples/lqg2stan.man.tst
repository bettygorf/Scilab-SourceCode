clear;lines(0);
ny=2;nu=3;nx=4;
P22=ssrand(ny,nu,nx);
bigQ=rand(nx+nu,nx+nu);bigQ=bigQ*bigQ';
bigR=rand(nx+ny,nx+ny);bigR=bigR*bigR';
[P,r]=lqg2stan(P22,bigQ,bigR);K=lqg(P,r);  //K=LQG-controller
spec(h_cl(P,r,K))      //Closed loop should be stable
//Same as Cl=P22/.K; spec(Cl('A'))
s=poly(0,'s')
lqg2stan(1/(s+2),eye(2,2),eye(2,2))
