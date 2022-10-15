function [w0,l]=specfact(a,b,c,d)
//Syntax : [w0,l]=specfact(a,b,c,d)
//
//Etant donnee la matrice de densite spectrale :
//                 -1                   -1
//     r + c*(s*i-a) * b  +  b'*(-s*i-a') * c'  avec r=d+d'>0
//
//                                                  -1
//specfact calcule w0,l telles que w(s)=w0+l*(s*i-a) * b  soit un fac-
//teur spectral de phi(s). C'est a dire  phi(s)=w'(-s)*w(s)
//
//Voir aussi les macros dspec1, pspec
//!
//origine f. delebecque inria 1988.
//
r=d+d',w0=sqrt(d),
p=ricc(a-b/r*c,b/r*b',-c'/r*c,'cont')
l=w0\(c+b'*p)


