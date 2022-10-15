clear;lines(0);
rand('seed',0);sl=ssrand(2,2,5);[A,B,C,D]=abcd(sl);poles=spec(A)
[Q,M]=pbig(A,0,'c');  //keeping unstable poles
slred=projsl(sl,Q,M);spec(slred('A'))
sl('D')=rand(2,2);  //making proper system
trzeros(sl)  //zeros of sl
wi=inv(sl);  //wi=inverse in state-space
[q,m]=psmall(wi('A'),2,'d');  //keeping small zeros (poles of wi) i.e. abs(z)<2
slred2=projsl(sl,q,m);
trzeros(slred2)  //zeros of slred2 = small zeros of sl
//  Example keeping second order modes
A=diag([-1,-2,-3]);
sl=syslin('c',A,rand(3,2),rand(2,3));[nk2,W]=hankelsv(sl)
[Q,M]=pbig(W,nk2(2)-%eps,'c');    //keeping 2 eigenvalues of W
slr=projsl(sl,Q,M);  //reduced model
hankelsv(slr)
