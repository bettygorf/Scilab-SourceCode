function [t]=acos(x)
// Syntax : [t]=acos(x)
//
// Arccosine Cosine-inverse
// Entries of vector x must be in [-1, 1]
// Entries of T are in   ] 0,pi[ x ]-inf +inf[
//                 [0] x [0,+inf] et [pi] x ]-inf,0]     (real x imag)
//!
if type(x)<>1 then error(53),end
[m,n]=size(x)
if m<>n then t=-%i*log(x+%i*sqrt(ones(m,n)-x.*x))
        else t=-%i*log(x+%i*sqrt(eye-x*x))
end
if m=n then if m*n>1 then return,end,end
if norm(imag(x))=0 then if maxi(abs(x))<=1 then t=real(t);end;end



