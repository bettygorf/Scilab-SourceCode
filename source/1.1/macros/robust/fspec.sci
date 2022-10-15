function [gm]=fspec(g) computes a spectral factorization:
//        g = gtild(gm)*gm
//with stable gm and gm^-1  ( gm^-1 = invsysli(gm) ).
//-- g: syslin list defining the linear system g
//-- gm: 
//Assumptions:
//- g is invertible ( inv(D) exists ),
//- g and g^1 (invsysli(g)) have no poles on the imaginary axis.
//- gtild(g) = g.
//  (poles and zeros of g are symmetric wrt imaginary axis))
//- g(+oo) = D is positive definite.
//!
flag='ss';if G(1)='r' then flag='tf';G=tf2ss(G);end
      [r1,r,d]=dtsi(g),[a,b,c]=r(2:4),
      ari=a-b*inv(d)*c,
      rri=b*inv(d)*b',qri=-c'*inv(d)*c,
      x=riccati(ari,rri,qri,'c'),
      id=sqrt(d),
      gm=syslin('c',a,b,inv(id)*(c+b'*x),id),
      gm=minss(gm)
if flag='tf' then gm=ss2tf(gm);end;

