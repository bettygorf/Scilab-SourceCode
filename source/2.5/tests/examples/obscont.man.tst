clear;lines(0);
ny=2;nu=3;nx=4;P=ssrand(ny,nu,nx);[A,B,C,D]=abcd(P);
Kc=-ppol(A,B,[-1,-1,-1,-1]);  //Controller gain
Kf=-ppol(A',C',[-2,-2,-2,-2]);Kf=Kf';    //Observer gain
cl=P/.(-obscont(P,Kc,Kf));spec(cl('A'))   //closed loop system
[J,r]=obscont(P,Kc,Kf);
Q=ssrand(nu,ny,3);Q('A')=Q('A')-(maxi(real(spec(Q('A'))))+0.5)*eye(Q('A')) 
//Q is a stable parameter
K=lft(J,r,Q);
spec(h_cl(P,K))  // closed-loop A matrix (should be stable);
