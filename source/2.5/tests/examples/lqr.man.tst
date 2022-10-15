clear;lines(0);
A=rand(2,2);B=rand(2,1);   //two states, one input
Q=diag([2,5]);R=2;     //Usual notations x'Qx + u'Ru
Big=sysdiag(Q,R);    //Now we calculate C1 and D12
[w,wp]=fullrf(Big);C1=w(:,1:2);D12=w(:,3);   //[C1,D12]'*[C1,D12]=Big
P=syslin('c',A,B,C1,D12);    //The plant (continuous-time)
[K,X]=lqr(P)
spec(A+B*K)    //check stability
norm(A'*X+X*A-X*B*inv(R)*B'*X+Q,1)  //Riccati check
P=syslin('d',A,B,C1,D12);    // Discrete time plant
[K,X]=lqr(P)     
spec(A+B*K)   //check stability
norm(A'*X*A-(A'*X*B)*pinv(B'*X*B+R)*(B'*X*A)+Q-X,1) //Riccati check
