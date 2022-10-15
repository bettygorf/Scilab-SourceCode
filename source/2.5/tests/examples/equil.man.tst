clear;lines(0);
P=rand(4,4);P=P*P';
Q=rand(4,4);Q=Q*Q';
T=equil(P,Q)
clean(T*P*T')
clean(inv(T)'*Q*inv(T))
