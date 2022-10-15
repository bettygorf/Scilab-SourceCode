function [ar]=armac(a,b,d,ny,nu,sig)
// Renvoit une liste Scilab qui decrit un systeme ARMACX
//   A(z^-1)y= B(z^-1)u + D(z^-1)sig*e(t)
//   a=<Id,a1,..,a_r>; matrice (ny,r*ny)
//   b=<b0,.....,b_s>; matrice (ny,(s+1)*nu)
//   d=<Id,d1,..,d_p>; matrice (ny,p*ny);
//   ny : dimension de l'observation y
//   nu : dimension de la commande u
//   sig : matrice (ny,ny);
//
//!
[na,la]=size(a);
if na<>ny,write(%io(2),"a(:,1) must be of dimension "+string(ny));end
[nb,lb]=size(b);
if nb<>ny,write(%io(2),"b(:,1) must be of dimension "+string(ny));end
[nd,ld]=size(d);
if nd<>ny,write(%io(2),"d(:,1) must be of dimension "+string(ny));end
ar=list('ar',a,b,d,ny,nu,sig)



