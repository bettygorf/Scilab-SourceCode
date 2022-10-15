function [z]=milk_drop(x,y)
// chute d'une goutte de lait.
//!
sq=x**2+y**2;
z= exp( exp(-sq).*(exp(cos(sq)**20)+8*sin(sq)**20+2*sin(2*(sq))**8) );


