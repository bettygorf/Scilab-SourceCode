function [t]=coth(x)
//Syntax : [t]=coth(x)
//
// hyperbolic co-tangent of x
//!
if type(x)<>1 then error(53),end
[m,n]=size(x);
t=exp(x);
if m<>n then t=(t-ones(m,n)./t).\(t+ones(m,n)./t)
        else ti=inv(t);t=(t-ti)\(t+ti)
end



