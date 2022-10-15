clear;lines(0);
S1=ssrand(2,2,3);S2=ssrand(2,2,2);
W=S1/.S2;
ss2tf(S1/.S2)
//Same operation by LFT:
ss2tf(lft([zeros(2,2),eye(2,2);eye(2,2),-S2],S1))
//Other approach: with constant feedback
BigS=sysdiag(S1,S2); F=[zeros(2,2),eye(2,2);-eye(2,2),zeros(2,2)];
Bigclosed=BigS/.F;
W1=Bigclosed(1:2,1:2);   //W1=W (in state-space).
ss2tf(W1)
//Inverting
ss2tf(S1*inv(eye()+S2*S1))
