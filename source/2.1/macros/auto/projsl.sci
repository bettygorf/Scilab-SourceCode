function [slp]=projsl(sl,q,m)
//slp= projected model of sl q*m is the full rank 
//factorization of the projection.
//!
slp=list('lss',m*sl(2)*q,m*sl(3),sl(4)*q,sl(5),m*sl(6),sl(7))

