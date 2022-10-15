function [t]=atanh(x)
//Syntax : <t>=atanh(x)
//
//Hyperbolic tangent inverse 
//Entries of x must be in ]-1,1[
//Entries of T are in          ] inf,inf[ x ]-pi/2,pi/2[
//                             ]-inf, 0 [ x [-pi/2]
//                      and    ]  0 ,inf[ x [pi/2]
//
//!
if type(x)<>1 then error(53),end
[m,n]=size(x)
if m<>n then t=log((ones(m,n)+x).*sqrt(ones(m,n)/(ones(m,n)-(x.*x))))
        else t=log((eye+x)*sqrt(eye/(eye-x*x)))
end


