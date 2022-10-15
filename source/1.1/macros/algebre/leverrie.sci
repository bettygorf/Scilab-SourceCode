function [num,den]=leverrier(h,f,g)
//[num,den]=leverrier(h,f,g) computes the transfer matrix num./den
// such that:
//             num./den = h*(s*eye-f)**(-1)*g
// by Leverrier's algorithm.
// Use preferably ss2tf. See also glever, coff, coffg, detr, determ.
//!
[n,n]=size(f)
z=poly(0,'z');
num=h*g
den=1
x=eye(n,n)
for k=1:n-1,
         x=x*f,
         d=-sum(diag(x))/k,
         den=z*den+d,
         x=x+d*eye,
         num=z*num+h*x*g,
end;
den=z*den-sum(diag(x*f))/n



