function t=cosh(x)
//Syntax : t=cosh(x)
//
//t hyperbolic cosine of x
//!
if type(x)<>1 then error(53),end
t=exp(x);
t=(t+ones(x)./t)/2




