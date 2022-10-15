clear;lines(0);
A=-diag(1:3);C=rand(2,3);
Go=obs_gram(A,C,'c');     // <=> w=syslin('c',A,[],C); Go=obs_gram(w);
norm(Go*A+A'*Go+C'*C,1)
norm(lyap(A,-C'*C,'c')-Go,1)
A=A/4; Go=obs_gram(A,C,'d');    //discrete time case
norm(lyap(A,-C'*C,'d')-Go,1)
