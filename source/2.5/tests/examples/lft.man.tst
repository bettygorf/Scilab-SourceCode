clear;lines(0);
s=poly(0,'s');
P=[1/s, 1/(s+1); 1/(s+2),2/s]; K= 1/(s-1);
lft(P,K)
lft(P,[1,1],K)
P(1,1)+P(1,2)*K*inv(1-P(2,2)*K)*P(2,1)   //Numerically dangerous!
ss2tf(lft(tf2ss(P),tf2ss(K)))
lft(P,-1)
f=[0,0;0,1];w=P/.f; w(1,1)
//Improper plant (PID control)
W=[1,1;1,1/(s^2+0.1*s)];K=1+1/s+s
lft(W,[1,1],K); ss2tf(lft(tf2ss(W),[1,1],tf2ss(K)))
