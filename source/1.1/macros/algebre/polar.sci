function [Ro,Teta]=polar(A);
//[Ro,Teta]=polar(A);
// Polar form of A
// A=Ro*exp(%i*Teta) Ro symmetric >=0 
// Teta hermitian >=0
//F.D.
//!
[u,s,v]=svd(a);
ro1=U*sqrt(s);
ro=ro1*ro1';
W=U*V';
// A = Ro*W   (Ro sdp ; W unit)
// W=exp(%i*Teta)
//
[ab,x,bs]=bdiag(w+0*%i*w);
z=log(diag(ab));
lw=x*diag(z)*inv(x);
Teta=-%i*lw;



