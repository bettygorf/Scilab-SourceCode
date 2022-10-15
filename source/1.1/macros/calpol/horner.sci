function [r]=horner(P,x)
// horner(P,x) evaluates the polynomial or rational matrix P = P(s) 
// when the variable s of the polynomial is replaced by x
// x can be a scalar or polynomial or rational matrix.
// Example: bilinear transform; Assume P = P(s) is a rational matrix
// then the rational matrix P((1+s)/(1-s)) is obtained by
// horner(P,(1+s)/(1-s));
// To evaluate a rational matrix at given frequencies use 
// preferably the freq primitive ;
// See also: freq, repfreq.
//!
//
if type(p)=15 then r=horner(p(2),x)./horner(p(3),x),return,end
[m,n]=size(p)
r=[]
for l=1:m
  rk=[]
  for k=1:n
   plk=p(l,k)
   d=degree(plk)
   rlk=coeff(plk,d);
   for kk=1:d,
     rlk=rlk*x+coeff(plk,d-kk)*eye;
   end;
   rk=[rk rlk]
  end
  r=[r;rk]
end

