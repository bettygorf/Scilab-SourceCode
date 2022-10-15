function [Pn,Rt,T]=faurre(n,H,F,G,r0)
//[Pn,Rt,T]=faurre(n,H,F,G,r0)
//macro which computes iteratively the minimal solution of the algebraic
//Riccati equation and gives the matrices Rt and Tt of the filter model.
//   n     : number of iterations.
//   H,F,G : estimated triple from the covariance sequence of y.
//   r0    : E(yk*yk')
//   Pn    : solution of the Riccati equation after n iterations.
//   Rt,T  : gain matrix of the filter.
//!
//author: G. Le Vey  Date: 16 Febr. 1989
 
   for k=1:n, A=(G-F*Pn*H');Pn=F*Pn*F'+A*inv(r0-H*Pn*H')*A',end;
   Rt=r0-H*Pn*H';
   T=(G-F*Pn*H')*inv(Rt);



