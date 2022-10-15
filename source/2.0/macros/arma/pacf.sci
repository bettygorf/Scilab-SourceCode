function [phi]=pacf(x,n,min,max)
// function pacf(x,n,[min,max])
// Partial Autocorrelation function for one-dimensional process
//
[lhs,rhs]=argn(0)
if rhs <= 1 ; n=prod(size(x))/4;end
if rhs <= 2 ; min=-1.0;end
if rhs <= 3 ; max=1.0;end
[cov,mean]=corr(x,n+1);
ac=cov'/cov(1);
xtitle('Partial Autocorrelation Function ');
// Version recursive 
// phi[k] the k-th partial autocorrelation coefficient is defined 
// as the k-the element of psi which solves mat(1:k,1:k) psi = ac(2:k+1)
// this can be done like this 
//mat=1/2*diag(ones(1,n));
//for k=1:n-1; mat=mat+ac(k+1)*diag(ones(1,n-k),k);end
//mat=mat+mat';
//phi=[];for k=1:n;psi=mat(1:k,1:k)\ac(2:k+1); phi=[phi,psi(k)];end
// but we can recursively computes the phi[k] more efficiently
phi=0*ones(n,1)
phi(1)=ac(2)
psi=phi(1);
for k=2:n;phi(k)=ac(k+1)- ac(k:-1:2)'*psi;psi=[psi;phi(k)];end
plot2d3("onn",(1:n)',phi,[-1],"011"," ",[0,min,n,max]);
stde=2*sqrt(1/prod(size(x)));
plot2d( [0,0,0;n,n,n],[0,stde,-stde;0,stde,-stde],[-1,-2,-2],"000")





