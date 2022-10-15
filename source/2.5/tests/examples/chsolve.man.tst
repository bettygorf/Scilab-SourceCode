clear;lines(0);
A=sprand(20,20,0.1);
A=A*A'+eye();  
spcho=chfact(A);
sol=(1:20)';rhs=A*sol;
spcho=chfact(A);
chsolve(spcho,rhs)
