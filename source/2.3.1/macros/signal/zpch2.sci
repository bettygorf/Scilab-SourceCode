function [zers,pols,gain]=zpch2(n,A,omegar)
//[zers,pols,gain]=zpch2(n,A,omegar)
//Poles and zeros of a type 2 Chebyshev analog filter
//gain is the gain of the filter
//H(s)=gain*poly(zers,'s')/poly(pols,'s')
//  n      :Filter order
//  A      :Attenuation in stop band (A>1)
//  omegar :Cut-off frequency in Hertz
//  zers   :Resulting filter zeros
//  pols   :Resulting filter poles
//  gain   :Resulting filter gain
//
//!
//Author F.D.
//Revised by C. Bunks Oct. 24, 1996  
un=ones(1,n);
v=%pi/(2*n)*(1:2:2*n-1);
w=exp(%i*v);
cosine=real(w);
sine=imag(w);
n2=int(n/2);
if n=2*n2 then,
  zers=%i*omegar*un./cosine;
else,
  zers=%i*omegar*un(1:n-1)./[cosine(1:n2),cosine(n2+2:n)];
end,
gamma=(A+sqrt(A*A-1))**(1/n);
alpha=-((gamma-1/gamma)/2)*sine;
beta=((gamma+1/gamma)/2)*cosine;
normal=alpha.*alpha+beta.*beta;
pols=omegar*(alpha-%i*beta)./normal;
gain=abs(real(prod(pols)/prod(zers)));
 



