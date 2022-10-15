function [Pn,Rt,T]=lindquist(n,H,F,G,r0)
//[Pn,Rt,T]=lindquist(n,H,F,G,r0)
//macro which computes iteratively the minimal solution of the algebraic
//Riccati equation and gives the matrices Rt and Tt of the filter model,
//by the lindquist algorithm.
//   n     : number of iterations.
//   H,F,G : estimated triple from the covariance sequence of y.
//   r0    : E(yk*yk')
//   Pn    : solution of the Riccati equation after n iterations.
//   Rt,Tt : gain matrices of the filter.
//!
//author: G. Le Vey  Date: 16 Febr. 1989
 
//initialization
   [d,m]=size(H);
   gam=G;
   Rt=r0;
   k=0*ones(m,d);
//recursion
   for j=1:n,..
     k=k+gam/Rt*gam'*H';
     r1=r0-H*k;
     gam=(F-(G-F*k)/r1*H)*gam;
     Rt=Rt-gam'*H'/r1*H*gam;
   end
   Rt=inv(r0-H*k);
   tt=(G-F*k)/Rt;



