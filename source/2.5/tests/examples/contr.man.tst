clear;lines(0);
W=ssrand(2,3,5,list('co',3));  //cont. subspace has dim 3.
A=W("A");B=W("B");
[n,U]=contr(A,B);n
A1=U'*A*U;
spec(A1(n+1:$,n+1:$))  //uncontrollable modes
spec(A+B*rand(3,5))    
