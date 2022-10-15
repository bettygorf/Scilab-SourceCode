function [Ns,d]=coffg(Fs)
// [Ns,d]=coffg(Fs) computes Fs^-1 where Fs is a polynomial
// matrix by co-factors method.
// d = common denominator; Ns =  numerator (matrix polynomial)
// Fs inverse = Ns/d.
// (Be patient...results are generally reliable)
//F.D. 
// See also determ, detr, invr, penlaur, glever, leverrier 
//!
//
if type(Fs)<>2 then 
    error('First argument to coffg must be a polynomial matrix'),end
[lhs,rhs]=argn(0);
[n,np]=size(Fs);
if n<>np then error('First argument to coffg must be square!');end
d=determ(Fs) // common denominator
n1=n;
for kk=1:n1,for l=1:n1,
   signe=(-1)^(kk+l);
   col=[1:kk-1,kk+1:n1];row=[1:l-1,l+1:n1];
   Ns(kk,l)=-signe*determ(Fs(row,col))
end;end
Ns=-Ns;





