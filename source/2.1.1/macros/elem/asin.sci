function [t]=asin(x)
//Syntax : [t]=asin(x)
//
//Sine-inverse of x
//Entries of vector x must be in [-1,+1]
//Entries of t are in    ]-pi/2,pi/2[ x ]-inf,+inf[
//                   -pi/2 x [0,+inf] and pi/2 x ]-inf,0] (real x imag)
//
//!
if type(x)<>1 then error(53),end
[m,n]=size(x)
if m<>n then t=-%i*log(%i*x+sqrt(ones(m,n)-x.*x))
        else t=-%i*log(%i*x+sqrt(eye-x*x))
end
if m=n then if m*n>1 then return,end,end
if norm(imag(x))=0 then if maxi(abs(x))<=1 then t=real(t);end;end



