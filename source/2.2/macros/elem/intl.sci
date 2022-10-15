function [r]=intl(a,b,z0,r,f)
//If f is a complex-valued macro, intl(a,b,z0,r,f) computes
//the integral of f(z)dz along the curve
//in the complex plane defined by z0 + r.exp(%i*t) for
//a<=t<=b .(part of the circle with center z0 and radius r
//with phase between a and b)
//!
//Author F.D.
//First compile f if necessary:
if type(f)=11 then comp(f),end;
//Define two functions for the real part and
//imaginary part of f(g(t))*g'(t) where g(t) is a 
//parametrization of the circle.
deff('<y>=real1(t)','z=z0+r*exp(%i*((1-t)*a+t*b)),...
y=real(f(z)*%i*(b-a)*z)')
deff('<y>=imag1(t)','z=z0+r*exp(%i*((1-t)*a+t*b)),...
y=imag(f(z)*%i*(b-a)*z)')
comp(real1),comp(imag1)
r=intg(0,1,real1)+%i*intg(0,1,imag1)

