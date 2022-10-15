clear;lines(0);
W1=ssrand(2,2,5);trzeros(W1)    //call trzeros
roots(det(systmat(W1)))         //roots of det(system matrix)
s=poly(0,'s');W=[1/(s+1);1/(s-2)];W2=(s-3)*W*W';[nt,dt,rk]=trzeros(W2);
St=systmat(tf2ss(W2));[Q,Z,Qd,Zd,numbeps,numbeta]=kroneck(St);
St1=Q*St*Z;rowf=(Qd(1)+Qd(2)+1):(Qd(1)+Qd(2)+Qd(3));
colf=(Zd(1)+Zd(2)+1):(Zd(1)+Zd(2)+Zd(3));
roots(St1(rowf,colf)), nt./dt     //By Kronecker form
