function [ar]=armac(a,b,d,ny,nu,sig)
// just build a tlist for storing armacx coefficients 
//   A(z^-1)y= B(z^-1)u + D(z^-1)sig*e(t)
//   a=<Id,a1,..,a_r>; matrix (ny,r*ny)
//   b=<b0,.....,b_s>; matrix (ny,(s+1)*nu)
//   d=<Id,d1,..,d_p>; matrix (ny,p*ny);
//   ny : dim of observation y 
//   nu : dim of control  u
//   sig : standard deviation  (ny,ny);
//
//!
// Copyright INRIA
[na,la]=size(a);
if na<>ny,write(%io(2),"a(:,1) must be of dimension "+string(ny));end
[nb,lb]=size(b);
if nb<>ny,write(%io(2),"b(:,1) must be of dimension "+string(ny));end
[nd,ld]=size(d);
if nd<>ny,write(%io(2),"d(:,1) must be of dimension "+string(ny));end
ar=tlist(['ar','a','b','d','ny','nu','sig'],a,b,d,ny,nu,sig);

