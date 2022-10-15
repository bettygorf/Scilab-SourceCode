function [P,r]=lqg2stan(P22,Q,R)
//P = standard plant for LQG control problem
//described by the triple (A,B,C)
//  . 
//  x = Ax + w1 + Bu   (resp x[n+1]= ... if dom='d')
//  
//  y = Cx + w2
//
//  cov(w1,w2)=R;
//
//  mininize (x,u)'Q(x,u)
//
[A,B,C,D22]=P22(2:5);
[nx,nu]=size(B);
[ny,nx]=size(C);
Qhalf=real(sqrt(Q));
Rhalf=real(sqrt(R));
B1=Rhalf(1:nx,:);D21=Rhalf(nx+1:nx+ny,:);
B2=B;
C1=Qhalf(:,1:nx);D12=Qhalf(:,nx+1:nx+nu);
C2=C;
D11=0*C1*B1;
dom=P22(7);
if dom==[] then warning('lqg2stan: time domain (?) assumed continuous');end
P=syslin(dom,A,real([B1,B2]),real([C1;C2]),real([D11,D12;D21,D22]));
r=size(C2*B2);


