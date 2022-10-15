function [t]=asinh(x)
// Syntax : [t]=asinh(x)
//
// Hyperbolic sine inverse of x
// Entries of x must be in ]-1,i[
// Entries of t are in    ]-inf,inf[ x ]-pi/2,pi/2[
//                             ]-inf, 0 ] x [-pi/2]
//                      and    [ 0  ,inf[ x [ pi/2]
//
//!
if type(x)<>1 then error(53),end
[m,n]=size(x)
if m<>n then t=log(x+sqrt(x.*x+ones(m,n)))
        else t=log(x+sqrt(x*x+eye))
end



